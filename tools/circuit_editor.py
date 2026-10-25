# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""QL Racing Editor: Tk GUI, pixel/clipboard tools and native physics preview."""
from __future__ import annotations

import argparse
import copy
import hashlib
import json
import math
import queue
import threading
import time
from pathlib import Path
import tkinter as tk
from tkinter import ttk, filedialog, messagebox

from PIL import Image, ImageGrab, ImageTk

from editor_model import (ROOT, PALETTE, asset_size, asset_title, bitmap, import_track,
                          new_project, normalize_asset, open_project, quantize,
                          resample_closed, save_project, track_geometry, track_issues, ENV_KEYS, environment, theme, MUSIC_NAMES,
                          THEME_NAMES, ambience_preset, widen_track, jet_render)
from editor_preview import Camera, TestEngine, render

COLORS=dict(bg='#101820',panel='#17242e',canvas='#09121a',text='#e3edf2',muted='#92aaba',accent='#57d6c4',line='#324958')


def fingerprint(project,index):
    return hashlib.sha256(json.dumps((project,index),sort_keys=True).encode()).hexdigest()


class Editor:
    def __init__(self,root,project_path=None):
        self.root=root;root.title('QL-Zero · Éditeur de circuits')
        root.geometry(f'{min(1360,root.winfo_screenwidth()-80)}x{min(860,root.winfo_screenheight()-110)}+40+40');root.minsize(1050,690)
        root.configure(bg=COLORS['bg']);self._style()
        default=ROOT/'assets/project/classic_cup.qlr.json'
        self.project=open_project(default) if default.exists() else new_project()
        self.path=default if default.exists() else None;self.index=0;self.selected=0;self.asset='player'
        self.dirty=False;self.refreshing=False;self.undo_stack=[];self.redo_stack=[];self.engine=None;self.camera=None
        self.preview_dirty=True;self.keys=set();self.held_commands=set();self.paused=False;self.last_tick=time.perf_counter();self.accumulator=0
        self.rate_start=self.last_tick;self.rate_frames=0;self.pc_rate=0
        self.zoom=16;self.ink=1;self.detached=None;self.latest_export=None;self.export_hash=None;self.busy=False
        self.events=queue.Queue();self.dragging=False;self.grid=tk.BooleanVar(value=True);self.map_grid=tk.BooleanVar(value=True)
        self.rivals=tk.BooleanVar(value=True);self.far=tk.BooleanVar(value=False);self.wire=tk.BooleanVar(value=False)
        self.native=tk.BooleanVar(value=False);self.mode=tk.StringVar(value='Piloter');self.fit=tk.BooleanVar(value=True)
        self.white_transparent=tk.BooleanVar(value=False);self.status=tk.StringVar(value='Prêt · UNION20 conservé · Ctrl+S enregistrer · Ctrl+Z annuler')
        self._toolbar();self.tabs=ttk.Notebook(root);self.tabs.pack(fill='both',expand=True,padx=14,pady=(4,8))
        self.track_tab=ttk.Frame(self.tabs);self.art_tab=ttk.Frame(self.tabs);self.test_tab=ttk.Frame(self.tabs);self.cup_tab=ttk.Frame(self.tabs)
        for frame,title in ((self.track_tab,'  Circuit et relief  '),(self.art_tab,'  Graphismes  '),(self.test_tab,'  Aperçu et test  '),(self.cup_tab,'  Coupe  ')):self.tabs.add(frame,text=title)
        self._track_ui();self._art_ui();self._test_ui();self._cup_ui()
        ttk.Label(root,textvariable=self.status,style='Muted.TLabel',wraplength=1200).pack(fill='x',padx=18,pady=(0,10))
        for key,action in (('<Control-s>',self.save),('<Control-Shift-S>',lambda:self.save(True)),('<Control-o>',self.open),
                           ('<Control-z>',self.undo),('<Control-y>',self.redo),('<Control-v>',self.paste)):
            root.bind(key,lambda event,fn=action:(fn(),'break')[1])
        root.protocol('WM_DELETE_WINDOW',self.close)
        if project_path:
            try:self.project=open_project(project_path);self.path=Path(project_path)
            except Exception as exc:messagebox.showerror('Ouverture impossible',str(exc),parent=root)
        root.bind('<Destroy>',self._destroyed,add='+')
        self.refresh();self.loop_after=root.after(33,self.loop)

    def _destroyed(self,event):
        if event.widget is self.root:
            try:self.root.after_cancel(self.loop_after)
            except tk.TclError:pass

    def _style(self):
        style=ttk.Style(self.root);style.theme_use('clam')
        style.configure('.',background=COLORS['panel'],foreground=COLORS['text'],font=('Segoe UI',10),fieldbackground=COLORS['bg'])
        style.configure('TFrame',background=COLORS['panel']);style.configure('TLabel',padding=(0,3))
        style.configure('Muted.TLabel',foreground=COLORS['muted']);style.configure('Title.TLabel',font=('Segoe UI',14,'bold'))
        style.configure('TButton',padding=(10,6),background='#263d4c',borderwidth=0)
        style.map('TButton',background=[('active','#345769'),('disabled','#1d2a34')])
        style.configure('Accent.TButton',background='#176b60');style.map('Accent.TButton',background=[('active','#218e7d')])
        style.configure('TNotebook',background=COLORS['bg'],borderwidth=0);style.configure('TNotebook.Tab',padding=(15,9))
        style.map('TNotebook.Tab',background=[('selected',COLORS['panel'])],foreground=[('selected',COLORS['accent'])])
        style.map('TCombobox',fieldbackground=[('readonly',COLORS['bg'])],foreground=[('readonly',COLORS['text'])])
        style.configure('TEntry',padding=5);style.configure('TCheckbutton',padding=4)
        style.configure('Cup.Treeview',background='#f7fafc',fieldbackground='#f7fafc',
                        foreground='#17242e',rowheight=28,font=('Segoe UI',10))
        style.map('Cup.Treeview',foreground=[('selected','#ffffff'),('!selected','#17242e')],
                  background=[('selected','#22685f'),('!selected','#f7fafc')])
        style.configure('Cup.Treeview.Heading',background='#dce6ec',foreground='#17242e')
        self.root.option_add('*Listbox.background',COLORS['bg']);self.root.option_add('*Listbox.foreground',COLORS['text'])
        self.root.option_add('*Listbox.selectBackground','#22685f');self.root.option_add('*Listbox.selectForeground','white')

    def _toolbar(self):
        bar=ttk.Frame(self.root);bar.pack(fill='x',padx=14,pady=12)
        ttk.Label(bar,text='QL-ZERO  /  Atelier',style='Title.TLabel').pack(side='left',padx=(7,20))
        for title,action in (('Nouveau',self.new),('Ouvrir…',self.open),('Enregistrer',self.save),('Annuler',self.undo),('Rétablir',self.redo)):
            ttk.Button(bar,text=title,command=action).pack(side='left',padx=3)
        self.export_button=ttk.Button(bar,text='Exporter la coupe QL…',command=self.export_default,style='Accent.TButton');self.export_button.pack(side='right',padx=4)
        ttk.Button(bar,text='Tester le circuit',command=self.start_test).pack(side='right',padx=4)

    def _track_ui(self):
        holder=ttk.Frame(self.track_tab,width=310);holder.pack(side='right',fill='y');holder.pack_propagate(False)
        scroller=tk.Canvas(holder,bg=COLORS['panel'],highlightthickness=0)
        scrollbar=ttk.Scrollbar(holder,command=scroller.yview);scrollbar.pack(side='right',fill='y')
        scroller.configure(yscrollcommand=scrollbar.set);scroller.pack(fill='both',expand=True)
        side=ttk.Frame(scroller,padding=14);window=scroller.create_window(0,0,window=side,anchor='nw')
        side.bind('<Configure>',lambda event:scroller.configure(scrollregion=scroller.bbox('all')))
        scroller.bind('<Configure>',lambda event:scroller.itemconfigure(window,width=event.width))
        ttk.Label(side,text='Circuit',style='Title.TLabel').pack(anchor='w')
        self.track_combo=ttk.Combobox(side,state='readonly');self.track_combo.pack(fill='x',pady=6);self.track_combo.bind('<<ComboboxSelected>>',self.change_track)
        buttons=ttk.Frame(side);buttons.pack(fill='x',pady=4)
        ttk.Button(buttons,text='Ajouter',command=self.add_track).pack(side='left');ttk.Button(buttons,text='Dupliquer',command=self.duplicate_track).pack(side='left',padx=4)
        ttk.Button(side,text='Importer un circuit .qzt…',command=self.import_track).pack(fill='x',pady=4)
        self.name=tk.StringVar();self.width=tk.DoubleVar();self.song=tk.StringVar()
        for variable in (self.name,self.width,self.song):variable.trace_add('write',self.form_changed)
        ttk.Label(side,text='Nom QL · 16 caractères ASCII').pack(anchor='w',pady=(10,0));ttk.Entry(side,textvariable=self.name).pack(fill='x')
        ttk.Label(side,text='Demi-largeur de la route · 3 à 7').pack(anchor='w');ttk.Spinbox(side,from_=3,to=7,increment=.1,textvariable=self.width).pack(fill='x')
        wider=ttk.Frame(side);wider.pack(fill='x',pady=(5,0))
        ttk.Label(wider,text='Élargissement (%)').pack(side='left')
        self.widen_percent=tk.DoubleVar(value=10)
        ttk.Spinbox(wider,from_=1,to=50,increment=1,textvariable=self.widen_percent,width=6).pack(side='right')
        ttk.Button(side,text='Élargir ce circuit',command=self.widen_current_track).pack(fill='x',pady=4)
        ttk.Label(side,text='Musique').pack(anchor='w');ttk.Combobox(side,state='readonly',textvariable=self.song,values=MUSIC_NAMES).pack(fill='x')
        self.theme_name=tk.StringVar(value='Mute City')
        ttk.Label(side,text='Ambiance · préréglage graphique').pack(anchor='w')
        self.theme_combo=ttk.Combobox(side,state='readonly',textvariable=self.theme_name,values=THEME_NAMES);self.theme_combo.pack(fill='x')
        self.theme_info=tk.StringVar()
        ttk.Label(side,textvariable=self.theme_info,style='Muted.TLabel',wraplength=265).pack(fill='x')
        ttk.Button(side,text='Appliquer cette ambiance',command=self.apply_theme).pack(fill='x',pady=4)
        ttk.Button(side,text='Éditer les graphismes de l’ambiance…',command=self.edit_environment).pack(fill='x',pady=4)
        ttk.Button(side,text='Exporter la coupe (3-6 circuits)…',command=self.start_cup_export).pack(fill='x',pady=8)
        ttk.Button(side,text='Appliquer les réglages',command=self.apply_settings).pack(fill='x',pady=8)
        self.node_info=tk.StringVar();ttk.Label(side,textvariable=self.node_info,foreground=COLORS['accent']).pack(anchor='w',pady=(8,0))
        coords=ttk.Frame(side);coords.pack(fill='x');self.node_x=tk.DoubleVar();self.node_y=tk.DoubleVar()
        for label,var in (('X',self.node_x),('Y',self.node_y)):
            ttk.Label(coords,text=label).pack(side='left');ttk.Entry(coords,textvariable=var,width=7).pack(side='left',padx=4)
        ttk.Button(side,text='Déplacer le point',command=self.apply_point).pack(fill='x',pady=5)
        ttk.Button(side,text='Placer le départ sur ce point',command=self.set_start).pack(fill='x',pady=4)
        for title,action in (('Espacer régulièrement les 32 points',self.resample),('Adoucir la courbe',self.smooth),('Inverser le sens de course',self.reverse)):
            ttk.Button(side,text=title,command=action).pack(fill='x',pady=3)
        ttk.Checkbutton(side,text='Afficher la grille',variable=self.map_grid,command=self.draw_map).pack(anchor='w')
        self.issue_text=tk.StringVar();ttk.Label(side,textvariable=self.issue_text,wraplength=262,style='Muted.TLabel').pack(fill='x',pady=8)
        def bind_scroll(widget):
            widget.bind('<MouseWheel>',lambda event:(scroller.yview_scroll(-1 if event.delta>0 else 1,'units'),'break')[1])
            for child in widget.winfo_children():bind_scroll(child)
        bind_scroll(side)
        left=ttk.Frame(self.track_tab,padding=12);left.pack(fill='both',expand=True)
        ttk.Label(left,text='Glisse les points pour dessiner la piste. Le point 1 indique le départ.',style='Muted.TLabel').pack(anchor='w')
        self.map=tk.Canvas(left,bg=COLORS['canvas'],highlightthickness=0);self.map.pack(fill='both',expand=True,pady=8)
        self.map.bind('<Configure>',lambda event:self.draw_map());self.map.bind('<Button-1>',self.map_down)
        self.map.bind('<B1-Motion>',self.map_drag);self.map.bind('<ButtonRelease-1>',self.map_up)
        self.map.bind('<Button-3>',self.map_menu)
        ttk.Label(left,text='Relief QL · glisse le profil pour régler l’horizon (−32 à +32, par pas de 4).').pack(anchor='w')
        self.hill=tk.Canvas(left,height=116,bg=COLORS['canvas'],highlightthickness=0);self.hill.pack(fill='x',pady=6)
        self.hill.bind('<Configure>',lambda event:self.draw_hills());self.hill.bind('<Button-1>',self.hill_down)
        self.hill.bind('<B1-Motion>',self.hill_drag);self.hill.bind('<ButtonRelease-1>',self.map_up)
        ttk.Label(left,text='32 tronçons de route · 64 points pour l’IA et le relief · recharge rose aux tronçons 17–18 · pad au tronçon 3',style='Muted.TLabel').pack(anchor='w')

    def _art_ui(self):
        side=ttk.Frame(self.art_tab,padding=14,width=290);side.pack(side='left',fill='y');side.pack_propagate(False)
        ttk.Label(side,text='Graphismes QL',style='Title.TLabel').pack(anchor='w')
        self.asset_keys=list(self.project['assets']);self.asset_list=tk.Listbox(side,borderwidth=0,highlightthickness=0,exportselection=False,font=('Segoe UI',9))
        scroll=ttk.Scrollbar(side,command=self.asset_list.yview);self.asset_list.configure(yscrollcommand=scroll.set)
        self.asset_list.pack(side='left',fill='both',expand=True,pady=8);scroll.pack(side='right',fill='y',pady=8)
        self.asset_list.bind('<<ListboxSelect>>',self.select_asset)
        main=ttk.Frame(self.art_tab,padding=14);main.pack(fill='both',expand=True)
        scope=ttk.Frame(main);scope.pack(fill='x',pady=(0,8))
        ttk.Label(scope,text='Ambiance du circuit :').pack(side='left',padx=(0,8))
        self.art_track_combo=ttk.Combobox(scope,state='readonly',width=24);self.art_track_combo.pack(side='left')
        self.art_track_combo.bind('<<ComboboxSelected>>',self.change_art_track)
        ttk.Label(scope,text='Les sprites restent communs à la coupe.',style='Muted.TLabel').pack(side='left',padx=12)
        self.art_title=tk.StringVar();ttk.Label(main,textvariable=self.art_title,style='Title.TLabel').pack(anchor='w')
        self.art_help=tk.StringVar();ttk.Label(main,textvariable=self.art_help,wraplength=950,style='Muted.TLabel').pack(anchor='w',pady=4)
        ttk.Button(main,text='Remplir avec la couleur sélectionnée',command=self.fill_asset).pack(anchor='w',pady=4)
        toolbar=ttk.Frame(main);toolbar.pack(fill='x',pady=4)
        for title,action in (('Importer une image…',self.import_bitmap),('Coller le presse-papier',self.paste),('Exporter PNG…',self.export_bitmap),('Retourner ↔',self.flip_asset)):
            ttk.Button(toolbar,text=title,command=action).pack(side='left',padx=3)
        palette=ttk.Frame(main);palette.pack(fill='x',pady=8);self.palette_buttons=[]
        for c in range(-1,8):
            color='#313e4a' if c==-1 else '#%02x%02x%02x'%PALETTE[c]
            button=tk.Button(palette,text='∅' if c==-1 else str(c),width=4,bg=color,fg='white' if c in (-1,0,1,2,3) else 'black',
                             relief='flat',bd=2,command=lambda value=c:self.set_ink(value));button.pack(side='left',padx=2);self.palette_buttons.append(button)
        ttk.Label(palette,text='Clic droit : effacer').pack(side='left',padx=12)
        ttk.Checkbutton(palette,text='Grille',variable=self.grid,command=self.draw_art).pack(side='right')
        holder=ttk.Frame(main);holder.pack(fill='both',expand=True);holder.rowconfigure(0,weight=1);holder.columnconfigure(0,weight=1)
        self.art_canvas=tk.Canvas(holder,bg=COLORS['canvas'],highlightthickness=0)
        self.art_canvas.grid(row=0,column=0,sticky='nsew');ys=ttk.Scrollbar(holder,command=self.art_canvas.yview);xs=ttk.Scrollbar(holder,orient='horizontal',command=self.art_canvas.xview)
        ys.grid(row=0,column=1,sticky='ns');xs.grid(row=1,column=0,sticky='ew');self.art_canvas.configure(yscrollcommand=ys.set,xscrollcommand=xs.set)
        for button in (1,3):
            self.art_canvas.bind(f'<Button-{button}>',self.art_down);self.art_canvas.bind(f'<B{button}-Motion>',self.art_drag)
            self.art_canvas.bind(f'<ButtonRelease-{button}>',self.art_up)
        self.art_canvas.bind('<Configure>',lambda event:self.draw_art())
        options=ttk.Frame(main);options.pack(fill='x',pady=8)
        ttk.Button(options,text='−',command=lambda:self.change_zoom(-2)).pack(side='left');ttk.Button(options,text='+',command=lambda:self.change_zoom(2)).pack(side='left',padx=3)
        ttk.Button(options,text='Adapter à la fenêtre',command=self.fit_zoom).pack(side='left',padx=3)
        imports=ttk.Frame(main);imports.pack(fill='x')
        ttk.Checkbutton(imports,text='Conserver les proportions à l’import',variable=self.fit).pack(side='left',padx=4)
        ttk.Checkbutton(imports,text='Blanc transparent à l’import',variable=self.white_transparent).pack(side='left',padx=8)

    def _test_ui(self):
        bar=ttk.Frame(self.test_tab,padding=12);bar.pack(fill='x')
        mode=ttk.Combobox(bar,textvariable=self.mode,values=('Piloter','Caméra libre'),state='readonly',width=15);mode.pack(side='left',padx=4)
        mode.bind('<<ComboboxSelected>>',lambda event:self.change_mode())
        for label,action in (('Actualiser / départ',self.reset_test),('Pause',self.toggle_pause),('Au point sélectionné',self.jump_camera),('Détacher la fenêtre',self.detach)):
            ttk.Button(bar,text=label,command=action).pack(side='left',padx=3)
        ttk.Button(bar,text='Coupe native',command=lambda:self.start_cup_export(True)).pack(side='right',padx=3)
        options=ttk.Frame(self.test_tab,padding=(12,0));options.pack(fill='x')
        for label,var in (('Adversaires',self.rivals),('Vue sans limite',self.far),('Maillage',self.wire)):
            button=ttk.Checkbutton(options,text=label,variable=var);button.pack(side='left',padx=8)
            if var is self.rivals:self.rivals_button=button
        self.preview_label=tk.StringVar(value='Rendu PC · physique QL');ttk.Label(options,textvariable=self.preview_label,foreground=COLORS['accent']).pack(side='right',padx=8)
        self.test_canvas=tk.Canvas(self.test_tab,bg='#03080c',highlightthickness=0,takefocus=True);self.test_canvas.pack(fill='both',expand=True,padx=16,pady=10)
        self.bind_preview(self.test_canvas)
        self.test_note=tk.StringVar(value='Clique dans l’aperçu. ↑ / Z accélérer · ↓ / S freiner · ← → tourner · Espace boost · Entrée départ · Échap pause.')
        ttk.Label(self.test_tab,textvariable=self.test_note,wraplength=1220,style='Muted.TLabel').pack(fill='x',padx=16,pady=(0,5))
        ttk.Label(self.test_tab,text='Aperçu live : physique et IA de la coupe actuelle, HUD et mini-carte. Coupe native : export complet avec enchaînement et classement. Cadence PC, sans mesure des FPS du QL ; audio à vérifier sur QL / NanoQL.',wraplength=1220,style='Muted.TLabel').pack(fill='x',padx=16,pady=(0,10))

    def _cup_ui(self):
        pane=ttk.Frame(self.cup_tab,padding=22);pane.pack(fill='both',expand=True)
        ttk.Label(pane,text='Coupe QL-ZERO',style='Title.TLabel').pack(anchor='w')
        ttk.Label(pane,text='Trois à six courses, trois tours par course, un joueur et deux adversaires. L’ordre ci-dessous est celui du microdrive exporté.',wraplength=1000,style='Muted.TLabel').pack(anchor='w',pady=8)
        self.cup_list=ttk.Treeview(pane,columns=('order','name','music'),show='headings',height=5,selectmode='browse',style='Cup.Treeview')
        for key,title,width in (('order','Course',90),('name','Circuit',400),('music','Musique',300)):
            self.cup_list.heading(key,text=title);self.cup_list.column(key,width=width,anchor='w')
        self.cup_list.pack(fill='x',pady=10);self.cup_list.bind('<Double-1>',lambda event:self.edit_cup_track())
        bar=ttk.Frame(pane);bar.pack(fill='x')
        for title,action in (('Monter',lambda:self.move_cup_track(-1)),('Descendre',lambda:self.move_cup_track(1)),('Éditer ce circuit',self.edit_cup_track),('Exporter la coupe…',self.start_cup_export),('Tester la coupe native…',lambda:self.start_cup_export(True))):
            ttk.Button(bar,text=title,command=action).pack(side='left',padx=(0,8))
        self.cup_note=tk.StringVar();ttk.Label(pane,textvariable=self.cup_note,foreground=COLORS['accent']).pack(anchor='w',pady=12)
        for title,text in (
            ('Classement','1er : 100 points · 2e : 50 points · 3e : 25 points. Un crash provoque un GAME OVER : Entrée relance la coupe à zéro. La grille suivante inverse l’ordre d’arrivée de la course précédente.'),
            ('Boost et énergie','Boost disponible au tour 2 pour tous les pilotes. Le joueur conserve son dernier point d’énergie ; les bandes roses rechargent la jauge. Les adversaires boostent en ligne droite et gèrent leur réserve.'),
            ('Interface de course','Tours en haut à gauche · position /3 au centre · énergie et chronomètre à droite · vitesse sous 1500 km/h en bas à droite. Mini-carte en bas à gauche : joueur magenta, adversaires cyan et jaune.'),
            ('Alertes et chronos','Énergie critique : clignotement. Annonces dans le bandeau noir inférieur. Après la course : temps des trois tours et meilleur tour par circuit, conservé jusqu’au reset.')):
            ttk.Label(pane,text=title,font=('Segoe UI',11,'bold')).pack(anchor='w',pady=(12,0))
            ttk.Label(pane,text=text,wraplength=1000,style='Muted.TLabel').pack(anchor='w')

    def refresh_cup(self):
        self.cup_list.delete(*self.cup_list.get_children())
        for i,track in enumerate(self.project['tracks']):
            self.cup_list.insert('', 'end',iid=str(i),values=(i+1,track['name'],MUSIC_NAMES[track['music']]))
        self.cup_list.selection_set(str(self.index))
        self.cup_note.set('Prêt pour l’export de la coupe.' if 3<=len(self.project['tracks'])<=6 else 'L’export de la coupe nécessite trois à six circuits ; le projet peut en conserver davantage.')

    def edit_cup_track(self):
        selection=self.cup_list.selection()
        if not selection or not self.apply_settings():return
        self.index=int(selection[0]);self.selected=0;self.preview_dirty=True;self.native.set(False);self.refresh();self.tabs.select(self.track_tab)

    def move_cup_track(self,delta):
        selection=self.cup_list.selection()
        if not selection:return
        old=int(selection[0]);new=old+delta
        if not 0<=new<len(self.project['tracks']) or not self.apply_settings():return
        active=self.track;self.remember();track=self.project['tracks'].pop(old);self.project['tracks'].insert(new,track)
        self.index=next(i for i,t in enumerate(self.project['tracks']) if t is active)
        self.changed('Ordre des courses modifié.');self.refresh();self.cup_list.selection_set(str(new))

    def bind_preview(self,canvas):
        canvas.bind('<Button-1>',lambda event:canvas.focus_set());canvas.bind('<KeyPress>',self.key_down);canvas.bind('<KeyRelease>',self.key_up)
        canvas.bind('<FocusOut>',lambda event:(self.keys.clear(),self.held_commands.clear()));canvas.bind('<Button-3>',self.look_down);canvas.bind('<B3-Motion>',self.look_drag)

    def key_down(self,event):
        if event.state&4:
            actions={'s':lambda:self.save(bool(event.state&1)),'o':self.open,'z':self.undo,'y':self.redo,'v':self.paste}
            action=actions.get(event.keysym.lower())
            if action:action();return 'break'
        if event.keysym in ('Escape','Return'):
            if event.keysym in self.held_commands:return 'break'
            self.held_commands.add(event.keysym)
        self.keys.add(event.keysym)
        if event.keysym=='Escape':
            if not (self.engine and self.engine.cup_session):self.toggle_pause()
        elif event.keysym=='Return':
            if self.engine and self.engine.cup_session:self.engine.continue_cup();self.camera.reset(self.engine)
            else:self.reset_test()
        return 'break'

    def key_up(self,event):self.keys.discard(event.keysym);self.held_commands.discard(event.keysym)
    def look_down(self,event):event.widget.focus_set();self.look_at=(event.x,event.y)
    def look_drag(self,event):
        if self.camera and self.mode.get()=='Caméra libre':
            x,y=self.look_at;self.camera.angle=(self.camera.angle+(event.x-x)*.15)%256
            self.camera.pitch=max(-32,min(32,self.camera.pitch+(event.y-y)*.2));self.look_at=(event.x,event.y)

    @property
    def track(self):return self.project['tracks'][self.index]

    def asset_pixels(self):
        return environment(self.project,self.index)[self.asset] if self.asset in ENV_KEYS else self.project['assets'][self.asset]

    def set_asset_pixels(self,pixels):
        if self.asset in ENV_KEYS:
            preset,_=ambience_preset(self.project,self.index)
            self.track.setdefault('environment_preset',preset)
        owner=self.track.setdefault('environment',{}) if self.asset in ENV_KEYS else self.project['assets']
        owner[self.asset]=normalize_asset(self.asset,pixels,jet_render(self.project))
        if self.asset in ENV_KEYS:self.refresh_ambience()

    def refresh_ambience(self):
        preset,custom=ambience_preset(self.project,self.index)
        self.theme_name.set(preset)
        self.theme_info.set('Graphismes personnalisés pour ce circuit.' if custom else 'Préréglage graphique du circuit.')

    def apply_theme(self):
        preset=self.theme_name.get()
        if not self.apply_settings():return
        self.remember();self.track['environment']={k:normalize_asset(k,p) for k,p in theme(preset).items()};self.track['environment_preset']=preset
        self.changed('Ambiance appliquée au circuit sélectionné.');self.refresh()

    def widen_current_track(self):
        if not self.apply_settings():return
        try:
            old=self.track['width'];widened=widen_track(self.track,self.widen_percent.get())
        except (ValueError,tk.TclError) as exc:
            messagebox.showerror('Élargissement impossible',str(exc),parent=self.root);return
        self.remember();self.project['tracks'][self.index]=widened
        new=widened['width'];actual=100*(new/old-1)
        limit=' · limite de largeur sûre atteinte' if new<round(old*(1+self.widen_percent.get()/100),2) else ''
        self.changed(f'Circuit élargi de {actual:.1f} % · demi-largeur {old:g} → {new:g}{limit} · Ctrl+Z pour annuler.')
        self.refresh()

    def edit_environment(self):
        if not self.apply_settings():return
        self.asset='road';self.refresh();self.tabs.select(self.art_tab);self.fit_zoom()

    def change_art_track(self,event=None):
        self.track_combo.current(self.art_track_combo.current());self.change_track()
        self.art_track_combo.current(self.index)

    def fill_asset(self):
        if self.asset not in ENV_KEYS:return
        self.remember();w,h=asset_size(self.asset);self.set_asset_pixels([[self.ink]*w for _ in range(h)])
        self.changed();self.draw_art()

    def remember(self):
        self.undo_stack.append(copy.deepcopy(self.project));self.undo_stack=self.undo_stack[-50:];self.redo_stack.clear()

    def changed(self,message='Modifications non enregistrées'):
        self.dirty=True;self.preview_dirty=True;self.native.set(False);self.status.set(message);self.update_title()

    def update_title(self):
        self.root.title('QL-ZERO · '+(self.path.name if self.path else 'Nouveau projet')+(' *' if self.dirty else ''))

    def refresh(self):
        self.refreshing=True
        self.track_combo.configure(values=[t['name'] for t in self.project['tracks']]);self.track_combo.current(self.index)
        self.art_track_combo.configure(values=[t['name'] for t in self.project['tracks']]);self.art_track_combo.current(self.index)
        self.name.set(self.track['name']);self.width.set(self.track['width']);self.song.set(MUSIC_NAMES[self.track['music']])
        self.refresh_ambience()
        self.selected%=32;self.refresh_point();self.draw_map();self.draw_hills()
        self.asset_list.delete(0,'end')
        for key in self.asset_keys:self.asset_list.insert('end',asset_title(key))
        self.asset_list.selection_set(self.asset_keys.index(self.asset));self.draw_art();self.update_title();self.refresh_cup()
        self.refreshing=False
        self.export_button.configure(text='Exporter la coupe QL…')

    def form_changed(self,*args):
        if not self.refreshing:
            self.dirty=True;self.update_title();self.status.set('Réglages modifiés · appliquer, enregistrer ou tester pour les valider.')

    def refresh_point(self):
        self.node_info.set(f'Point {self.selected+1} / 32');x,y=self.track['points'][self.selected]
        self.node_x.set(round(x,2));self.node_y.set(round(y,2))

    def change_track(self,event=None):
        index=self.track_combo.current()
        if not self.apply_settings():self.track_combo.current(self.index);return
        self.index=index;self.selected=0;self.preview_dirty=True;self.native.set(False);self.refresh()

    def apply_settings(self):
        try:
            name=self.name.get().strip().upper();name.encode('ascii');width=self.width.get()
            if not 1<=len(name)<=16 or not 3<=width<=7:raise ValueError('Nom ASCII : 1–16 caractères ; demi-largeur : 3–7.')
            values=dict(name=name,width=round(width,2),music=MUSIC_NAMES.index(self.song.get()))
            if any(self.track[k]!=v for k,v in values.items()):
                self.remember();self.track.update(values);self.changed();self.refresh()
            return True
        except Exception as exc:messagebox.showerror('Réglages incorrects',str(exc),parent=self.root);return False

    def apply_point(self):
        try:
            point=[self.node_x.get(),self.node_y.get()]
            if any(not math.isfinite(v) or not 1<=v<=127 for v in point):raise ValueError('Coordonnées : 1–127.')
            self.remember();self.track['points'][self.selected]=point;self.changed();self.refresh()
        except Exception as exc:messagebox.showerror('Point incorrect',str(exc),parent=self.root)

    def map_position(self,event):
        size=min(self.map.winfo_width()-30,self.map.winfo_height()-20);x0=(self.map.winfo_width()-size)/2;y0=(self.map.winfo_height()-size)/2
        return [max(1,min(127,(event.x-x0)*128/size)),max(1,min(127,(event.y-y0)*128/size))]

    def draw_map(self):
        if not hasattr(self,'map'):return
        self.map.delete('all');w,h=self.map.winfo_width(),self.map.winfo_height();size=min(w-30,h-20)
        if size<20:return
        x0,y0=(w-size)/2,(h-size)/2
        def xy(p):return x0+p[0]*size/128,y0+p[1]*size/128
        self.map.create_rectangle(x0,y0,x0+size,y0+size,outline=COLORS['line'])
        if self.map_grid.get():
            for v in range(0,129,8):
                a,b=x0+v*size/128,y0+v*size/128
                self.map.create_line(a,y0,a,y0+size,fill='#172c3b');self.map.create_line(x0,b,x0+size,b,fill='#172c3b')
        try:
            mesh,_=track_geometry(self.track)
            for i in range(32):
                a,b=mesh[i*2],mesh[((i+1)*2)%64]
                for points,color in (([a[0],a[3],b[3],b[0]],'#bcd8e3'),([a[1],a[2],b[2],b[1]],'#245799' if i not in (16,17,2) else '#b244a4' if i in (16,17) else '#cda827')):
                    self.map.create_polygon(*(v for p in points for v in xy(p)),fill=color,outline='')
            issues=track_issues(self.track)
            self.issue_text.set('Export possible · collision, IA et dessin partagent le même tracé.' if not issues else 'À corriger avant export :\n'+'\n'.join(issues[:3]))
        except ValueError as exc:self.issue_text.set(str(exc))
        points=self.track['points']
        self.map.create_line(*(v for p in points+points[:1] for v in xy(p)),fill='#80b7cd',dash=(3,4))
        for i,p in enumerate(points):
            x,y=xy(p);r=7 if i==self.selected else 4
            self.map.create_oval(x-r,y-r,x+r,y+r,fill=COLORS['accent'] if i==self.selected else '#e5eaf0' if i==0 else '#547c92',outline=COLORS['canvas'])
            if i==self.selected or i==0:self.map.create_text(x+13,y-12,text=str(i+1),fill=COLORS['accent'],font=('Segoe UI',10,'bold'))
        if self.mode.get()=='Caméra libre' and self.camera:
            x,y=xy((self.camera.x,self.camera.y));self.map.create_oval(x-4,y-4,x+4,y+4,fill='#ffba5a',outline='')

    def map_down(self,event):
        p=self.map_position(event);self.selected=min(range(32),key=lambda i:math.dist(self.track['points'][i],p));self.remember();self.dragging=True
        self.refresh_point();self.draw_map();self.draw_hills()
    def map_drag(self,event):
        if self.dragging:self.track['points'][self.selected]=self.map_position(event);self.changed();self.refresh_point();self.draw_map()
    def map_up(self,event=None):
        self.dragging=False;self.draw_map();self.draw_hills()
    def map_menu(self,event):
        p=self.map_position(event);self.selected=min(range(32),key=lambda i:math.dist(self.track['points'][i],p));self.refresh_point();self.draw_map()
        menu=tk.Menu(self.root,tearoff=False);menu.add_command(label='Placer le départ ici',command=self.set_start)
        menu.add_command(label='Voir ce point en caméra libre',command=self.jump_camera);menu.tk_popup(event.x_root,event.y_root)
    def set_start(self):
        self.remember();i=self.selected;self.track['points']=self.track['points'][i:]+self.track['points'][:i]
        self.track['hills']=self.track['hills'][i*2:]+self.track['hills'][:i*2];self.selected=0;self.changed();self.refresh()
    def resample(self):
        try:self.remember();self.track['points']=resample_closed(self.track['points']);self.changed();self.refresh()
        except ValueError as exc:messagebox.showerror('Rééchantillonnage',str(exc),parent=self.root)
    def smooth(self):
        self.remember();ps=self.track['points'];self.track['points']=[[.2*ps[(i-1)%32][k]+.6*p[k]+.2*ps[(i+1)%32][k] for k in (0,1)] for i,p in enumerate(ps)]
        self.changed();self.refresh()
    def reverse(self):
        self.remember();self.track['points']=self.track['points'][:1]+self.track['points'][:0:-1]
        self.track['hills']=self.track['hills'][:1]+self.track['hills'][:0:-1];self.changed();self.refresh()

    def draw_hills(self):
        if not hasattr(self,'hill'):return
        self.hill.delete('all');w,h=self.hill.winfo_width(),self.hill.winfo_height()
        for value in (-32,-16,0,16,32):
            y=h/2-value*(h-20)/64;self.hill.create_line(28,y,w-8,y,fill=COLORS['line']);self.hill.create_text(14,y,text=str(value),fill=COLORS['muted'],font=('Segoe UI',8))
        ps=[(28+i*(w-36)/63,h/2-v*(h-20)/64) for i,v in enumerate(self.track['hills'])]
        self.hill.create_line(*(v for p in ps for v in p),fill=COLORS['accent'],width=2)
        x=28+self.selected*2*(w-36)/63;self.hill.create_line(x,4,x,h-4,fill='#cba34c',dash=(3,3))
    def hill_down(self,event):self.remember();self.dragging=True;self.hill_drag(event)
    def hill_drag(self,event):
        if not self.dragging:return
        i=max(0,min(63,round((event.x-28)*63/max(1,self.hill.winfo_width()-36))))
        value=max(-32,min(32,round((self.hill.winfo_height()/2-event.y)*64/max(1,self.hill.winfo_height()-20)/4)*4))
        self.track['hills'][i]=value;self.changed(f'Relief {i+1}/64 : horizon {96+value}');self.draw_hills()

    def select_asset(self,event=None):
        selected=self.asset_list.curselection()
        if selected:self.asset=self.asset_keys[selected[0]];self.art_canvas.xview_moveto(0);self.art_canvas.yview_moveto(0);self.fit_zoom()
    def set_ink(self,value):self.ink=value;self.draw_art()
    def draw_art(self):
        if not hasattr(self,'art_canvas'):return
        self.art_title.set(asset_title(self.asset)+(' · '+self.track['name'] if self.asset in ENV_KEYS else ' · commun'));self.art_canvas.delete('all');pixels=self.asset_pixels();w,h=asset_size(self.asset)
        text='Huit couleurs QL et transparence. Les sprites du joueur sont doublés sans interpolation.'
        if self.asset=='background':text='Colonnes de 8 pixels QL : clique pour régler la hauteur. Une couleur, base opaque de 8 pixels. À l’import sans alpha, la couleur dominante du haut devient transparente.'
        elif self.asset in ('road','ground','speed','repair','skybox'):text='Réglage propre au circuit sélectionné : 8 pixels répétés horizontalement. Choisis une couleur puis remplis, ou peins un motif.'
        elif self.asset=='clouds':text='Motif propre au circuit : 32 × 16 pixels, répété horizontalement en haut du ciel. Transparence = couleur du ciel. Collage bitmap disponible.'
        elif self.asset.startswith('explosion_'):text='8 images de 48 × 40 pixels. Palette native : transparent, rouge, jaune et blanc.'
        elif self.asset.startswith('jet_'):
            mount=jet_render(self.project)
            text=f'QL : colonnes 1–16 et 25–40 ; {mount["normal_height"]} lignes à l’accélération, {mount["boost_height"]} en boost. Le centre et les lignes inutilisées restent transparents.'
        self.art_help.set(text)
        art=bitmap(pixels,True).resize((w*self.zoom,h*self.zoom),Image.Resampling.NEAREST);self.art_photo=ImageTk.PhotoImage(art)
        self.art_canvas.create_image(16,16,image=self.art_photo,anchor='nw')
        self.art_canvas.configure(scrollregion=(0,0,w*self.zoom+32,h*self.zoom+32))
        if self.grid.get() and self.zoom>=8:
            for x in range(w+1):self.art_canvas.create_line(16+x*self.zoom,16,16+x*self.zoom,16+h*self.zoom,fill='#435464')
            for y in range(h+1):self.art_canvas.create_line(16,16+y*self.zoom,16+w*self.zoom,16+y*self.zoom,fill='#435464')
        for c,button in zip(range(-1,8),self.palette_buttons):button.configure(relief='sunken' if c==self.ink else 'flat')
    def change_zoom(self,amount):self.zoom=max(2,min(40,self.zoom+amount));self.draw_art()
    def fit_zoom(self):
        w,h=asset_size(self.asset);self.zoom=max(2,min(30,(self.art_canvas.winfo_width()-34)//w,(self.art_canvas.winfo_height()-34)//h));self.draw_art()
    def art_down(self,event):self.remember();self.dragging=True;self.art_drag(event)
    def art_drag(self,event):
        if not self.dragging:return
        x=int((self.art_canvas.canvasx(event.x)-16)//self.zoom);y=int((self.art_canvas.canvasy(event.y)-16)//self.zoom);w,h=asset_size(self.asset)
        if not (0<=x<w and 0<=y<h):return
        value=-1 if event.num==3 or event.state&0x400 else self.ink;p=copy.deepcopy(self.asset_pixels())
        if self.asset=='background':
            ink=value if value>=0 else next(c for row in p for c in row if c>=0);height=max(8,40-y) if value>=0 else 8
            for row in p:
                for xx,c in enumerate(row):
                    if c>=0:row[xx]=ink
            for yy in range(40):p[yy][x]=ink if yy>=40-height else -1
        else:
            if self.asset.startswith('jet_') and 16<=x<24:value=-1
            p[y][x]=value
        self.set_asset_pixels(p)
        self.changed();self.draw_art()
    def art_up(self,event=None):self.dragging=False
    def flip_asset(self):
        self.remember();self.set_asset_pixels([row[::-1] for row in self.asset_pixels()]);self.changed();self.draw_art()

    def apply_bitmap(self,image):
        if not isinstance(image,Image.Image):raise ValueError('Le presse-papier ne contient pas de bitmap ni de fichier image lisible.')
        key=self.asset;pixels=quantize(image,asset_size(key),self.fit.get() if key not in ('road','ground','speed','repair','skybox','clouds','background') else False,
                                      self.white_transparent.get(),key.startswith('explosion_'))
        if key=='background' and all(c>=0 for row in pixels for c in row):
            top=pixels[0];sky=max(range(8),key=lambda c:top.count(c))
            pixels=[[-1 if c==sky else c for c in row] for row in pixels]
        if key.startswith('jet_'):
            for row in pixels:row[16:24]=[-1]*8
        self.remember();self.set_asset_pixels(pixels);self.changed('Image convertie à la palette et au format QL.');self.draw_art()
    def import_bitmap(self):
        path=filedialog.askopenfilename(parent=self.root,title='Importer un bitmap',filetypes=[('Images','*.png *.bmp *.jpg *.jpeg *.gif *.webp'),('Tous les fichiers','*.*')])
        if path:
            try:
                with Image.open(path) as image:self.apply_bitmap(image.copy())
            except Exception as exc:messagebox.showerror('Import impossible',str(exc),parent=self.root)
    def paste(self):
        if self.tabs.select()!=str(self.art_tab):return
        try:
            value=ImageGrab.grabclipboard()
            if isinstance(value,list):
                for name in value:
                    try:
                        with Image.open(name) as image:value=image.copy();break
                    except (OSError,ValueError):continue
            self.apply_bitmap(value)
        except Exception as exc:messagebox.showerror('Collage impossible',str(exc),parent=self.root)
    def export_bitmap(self):
        path=filedialog.asksaveasfilename(parent=self.root,title='Exporter le graphisme',initialfile=self.asset+'.png',defaultextension='.png',filetypes=[('PNG','*.png')])
        if path:bitmap(self.asset_pixels()).save(path);self.status.set('Graphisme exporté : '+path)

    def confirm_unsaved(self):
        if not self.dirty:return True
        answer=messagebox.askyesnocancel('Projet modifié','Enregistrer les modifications du projet avant de continuer ?',parent=self.root)
        return self.save() if answer else answer is not None
    def new(self):
        if not self.confirm_unsaved():return
        from cup_courses import project
        self.project=project();self.index=self.selected=0;self.path=None;self.dirty=False;self.undo_stack.clear();self.redo_stack.clear();self.preview_dirty=True;self.native.set(False);self.refresh()
    def open(self):
        path=filedialog.askopenfilename(parent=self.root,title='Ouvrir un projet',filetypes=[('Projet QL Racing','*.qlr.json *.json')])
        if not path or not self.confirm_unsaved():return
        try:
            project=open_project(path);self.project=project;self.path=Path(path);self.index=self.selected=0;self.dirty=False
            self.undo_stack.clear();self.redo_stack.clear();self.preview_dirty=True;self.native.set(False);self.refresh();self.status.set('Projet ouvert : '+path)
        except Exception as exc:messagebox.showerror('Ouverture impossible',str(exc),parent=self.root)
    def save(self,as_new=False):
        if not self.apply_settings():return False
        path=self.path
        if as_new or path is None:
            value=filedialog.asksaveasfilename(parent=self.root,title='Enregistrer le projet',initialfile='circuits.qlr.json',defaultextension='.qlr.json',filetypes=[('Projet QL Racing','*.qlr.json')])
            if not value:return False
            path=Path(value)
        try:save_project(self.project,path);self.path=path;self.dirty=False;self.update_title();self.status.set('Projet enregistré : '+str(path));return True
        except Exception as exc:messagebox.showerror('Enregistrement impossible',str(exc),parent=self.root);return False
    def add_track(self):
        if len(self.project['tracks'])>=32:messagebox.showinfo('Circuits','Le projet peut contenir 32 circuits.',parent=self.root);return
        self.remember();track=copy.deepcopy(new_project()['tracks'][0]);track['name']='NEW CIRCUIT';track['hills']=[0]*64
        self.project['tracks'].append(track);self.index=len(self.project['tracks'])-1;self.selected=0;self.changed();self.refresh()
    def duplicate_track(self):
        if len(self.project['tracks'])>=32:messagebox.showinfo('Circuits','Le projet peut contenir 32 circuits.',parent=self.root);return
        self.remember();track=copy.deepcopy(self.track);track['name']=(track['name'][:11]+' COPY')[:16]
        self.project['tracks'].append(track);self.index=len(self.project['tracks'])-1;self.changed();self.refresh()
    def import_track(self):
        if len(self.project['tracks'])>=32:messagebox.showinfo('Circuits','Le projet peut contenir 32 circuits.',parent=self.root);return
        path=filedialog.askopenfilename(parent=self.root,title='Importer un circuit existant',filetypes=[('Circuit QL','*.qzt'),('Tous les fichiers','*.*')])
        if path:
            try:
                track=import_track(path);self.remember();self.project['tracks'].append(track);self.index=len(self.project['tracks'])-1;self.changed();self.refresh()
            except Exception as exc:messagebox.showerror('Import impossible',str(exc),parent=self.root)
    def undo(self):
        if self.undo_stack:self.redo_stack.append(copy.deepcopy(self.project));self.project=self.undo_stack.pop();self.index=min(self.index,len(self.project['tracks'])-1);self.changed('Dernière modification annulée.');self.refresh()
    def redo(self):
        if self.redo_stack:self.undo_stack.append(copy.deepcopy(self.project));self.project=self.redo_stack.pop();self.index=min(self.index,len(self.project['tracks'])-1);self.changed('Modification rétablie.');self.refresh()

    def ensure_engine(self):
        if self.engine is None or self.preview_dirty:
            self.engine=TestEngine(self.project,self.index);self.camera=Camera(self.engine);self.preview_dirty=False;self.accumulator=0;self.native.set(False)
    def start_test(self):
        if not self.apply_settings():return
        self.tabs.select(self.test_tab)
        try:self.ensure_engine();self.paused=False;self.last_tick=time.perf_counter();self.test_canvas.focus_set();self.status.set('Test PC : physique et IA natives UNION20 ; cadence indépendante de la machine QL.')
        except Exception as exc:self.paused=True;messagebox.showerror('Circuit à corriger',str(exc),parent=self.root)
    def reset_test(self):
        if not self.apply_settings():return
        try:self.ensure_engine();self.engine.reset();self.camera.reset(self.engine);self.keys.clear();self.accumulator=0;self.last_tick=time.perf_counter();self.paused=False
        except Exception as exc:messagebox.showerror('Test impossible',str(exc),parent=self.root)
    def change_mode(self):
        self.keys.clear();self.native.set(False)
        if self.mode.get()=='Caméra libre':
            if self.engine:self.camera.reset(self.engine)
            self.test_note.set('Caméra libre : Z/S avancer · Q/D glisser · ←/→ tourner · E/C monter/descendre · Shift accélérer · clic droit glissé viser. Le relief QL déplace l’horizon.')
        elif self.engine and self.engine.cup_session:self.test_note.set('Coupe native : Entrée démarre ou passe au classement / circuit suivant · flèches piloter · Espace boost dès le tour 2 · F4 fantôme en Time Attack · Échap pause.')
        else:self.test_note.set('Pilotage : ↑ / Z accélérer · ↓ / S freiner · ← → tourner · Espace boost (tour 2) · Entrée départ · Échap pause.')
    def toggle_pause(self):self.paused=not self.paused;self.keys.clear();self.accumulator=0;self.status.set('Aperçu en pause.' if self.paused else 'Aperçu actif.');self.last_tick=time.perf_counter()
    def jump_camera(self):
        self.mode.set('Caméra libre');self.start_test();self.change_mode()
        if self.camera:
            self.camera.x,self.camera.y=self.track['points'][self.selected];a,b=self.track['points'][self.selected],self.track['points'][(self.selected+1)%32]
            self.camera.angle=math.atan2(b[1]-a[1],b[0]-a[0])*256/math.tau%256
    def detach(self):
        self.start_test()
        if self.detached and self.detached.winfo_exists():self.detached.lift();return
        win=tk.Toplevel(self.root);win.title('QL Racing · Aperçu et test');win.geometry('880x710');win.configure(bg=COLORS['panel']);self.detached=win
        bar=ttk.Frame(win,padding=10);bar.pack(fill='x')
        box=ttk.Combobox(bar,textvariable=self.mode,values=('Piloter','Caméra libre'),state='readonly',width=16);box.pack(side='left');box.bind('<<ComboboxSelected>>',lambda event:self.change_mode())
        ttk.Button(bar,text='Départ',command=self.reset_test).pack(side='left',padx=6);ttk.Button(bar,text='Pause',command=self.toggle_pause).pack(side='left')
        self.detached_canvas=tk.Canvas(win,bg='#03080c',highlightthickness=0,takefocus=True);self.detached_canvas.pack(fill='both',expand=True,padx=12,pady=8);self.bind_preview(self.detached_canvas)
        ttk.Label(win,textvariable=self.test_note,wraplength=850,style='Muted.TLabel').pack(fill='x',padx=12,pady=8)
        def close():self.keys.clear();win.destroy();self.detached=None
        win.protocol('WM_DELETE_WINDOW',close);self.detached_canvas.focus_set()
    def activate_cup(self,folder):
        try:
            self.start_test();self.engine.load_cup(folder);self.camera.reset(self.engine)
            self.mode.set('Piloter');self.change_mode();self.native.set(True)
            self.status.set('Coupe native chargée · Entrée : départ / course suivante · Actualiser : nouvelle coupe. Audio à vérifier sur QL / NanoQL.')
            self.test_note.set('Coupe native : Entrée démarre ou passe au classement / circuit suivant · flèches piloter · Espace boost dès le tour 2 · F4 fantôme en Time Attack · Échap pause.')
        except Exception as exc:messagebox.showerror('Test de coupe impossible',str(exc),parent=self.root)

    def export_default(self):
        self.start_cup_export()

    def start_cup_export(self,native_test=False):
        if self.busy or not self.apply_settings():return
        if not 3<=len(self.project['tracks'])<=6:
            messagebox.showinfo('Coupe classique','La coupe utilise trois à six circuits, dans l’ordre du projet.',parent=self.root);return
        parent=filedialog.askdirectory(parent=self.root,title='Choisir le dossier qui recevra la nouvelle coupe QL')
        if not parent:return
        target=Path(parent)/('coupe_'+time.strftime('%Y%m%d_%H%M%S'))
        project=copy.deepcopy(self.project);stamp=fingerprint(project,self.index)
        self.busy=True;self.export_button.configure(state='disabled');self.status.set('Export de la coupe en cours…')
        def worker():
            try:
                from build_cup import build
                result=build(project,target,lambda msg:self.events.put(('progress',msg)))
                self.events.put(('cup_done',(target,result,stamp,native_test)))
            except Exception as exc:self.events.put(('error',str(exc)))
        threading.Thread(target=worker,daemon=True).start()

    def loop(self):
        try:
            while True:
                kind,value=self.events.get_nowait()
                if kind=='progress':self.status.set(value)
                else:
                    self.busy=False;self.export_button.configure(state='normal')
                    if kind=='error':messagebox.showerror('Export interrompu',value,parent=self.root);self.status.set('Export interrompu ; les fichiers du jeu original sont préservés.')
                    elif kind=='cup_done':
                        target,result,stamp,native_test=value;self.status.set('Coupe exportée : '+str(target))
                        if native_test and stamp==fingerprint(self.project,self.index):self.activate_cup(target)
                        else:messagebox.showinfo('Coupe QL exportée',f'{target}\n\nTrois à six courses, musiques des circuits et du menu, classement 10 / 7 / 5, grille inversée et boost IA.\nMicrodrive : qlzero_classic_cup.mdv',parent=self.root)
        except queue.Empty:pass
        now=time.perf_counter();dt=min(.12,now-self.last_tick);self.last_tick=now
        visible=self.tabs.select()==str(self.test_tab) or self.detached is not None
        if visible:
            try:
                self.ensure_engine()
                cup_session=self.engine.cup_session
                self.rivals_button.configure(state='disabled' if cup_session else 'normal')
                if cup_session:self.rivals.set(True)
                if not self.paused:
                    if self.mode.get()=='Caméra libre':self.camera.step(self.keys,dt)
                    else:
                        self.accumulator=min(.12,self.accumulator+dt)
                        while self.accumulator>=.02:self.engine.step(self.keys,self.rivals.get());self.accumulator-=.02
                if self.native.get() and self.mode.get()=='Piloter':
                    self.engine.cpu.word('far_depth',32767 if self.far.get() else 4096)
                    self.engine.cpu.word('opponents',int(self.rivals.get()))
                    self.engine.cpu.word('fps',self.pc_rate);image=self.engine.native_frame()
                else:image=render(self.engine,self.camera if self.mode.get()=='Caméra libre' else None,self.rivals.get(),self.far.get(),self.wire.get())
                self.rate_frames+=1
                if now-self.rate_start>=1:
                    self.pc_rate=round(self.rate_frames/(now-self.rate_start));self.rate_start=now;self.rate_frames=0
                self.preview_label.set(('Rendu QL natif' if self.native.get() else 'Rendu PC live')+f' · {self.pc_rate} images/s PC')
                canvases=[self.test_canvas]+([self.detached_canvas] if self.detached else [])
                self.test_photos=[]
                for canvas in canvases:
                    w,h=canvas.winfo_width(),canvas.winfo_height();width=min(w-12,(h-12)*4/3);height=width*3/4
                    if width>10:
                        photo=ImageTk.PhotoImage(image.resize((int(width),int(height)),Image.Resampling.NEAREST));self.test_photos.append(photo)
                        canvas.delete('all');canvas.create_image(w/2,h/2,image=photo)
                if self.paused:
                    for canvas in canvases:canvas.create_text(canvas.winfo_width()/2,canvas.winfo_height()/2,text='PAUSE',fill='white',font=('Segoe UI',22,'bold'))
            except Exception as exc:
                self.paused=True;self.status.set('Aperçu indisponible : '+str(exc))
                for canvas in [self.test_canvas]+([self.detached_canvas] if self.detached else []):
                    canvas.delete('all');canvas.create_text(30,30,anchor='nw',text='Corrige le circuit puis clique sur « Actualiser / départ ».\n'+str(exc),fill=COLORS['text'],width=800)
        else:self.rate_start=now;self.rate_frames=0
        self.loop_after=self.root.after(33,self.loop)

    def close(self):
        if self.busy:
            messagebox.showinfo('Export en cours','Attends la fin de l’export avant de fermer l’éditeur.',parent=self.root);return
        if self.confirm_unsaved():self.root.destroy()


def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('project',nargs='?');args=parser.parse_args()
    root=tk.Tk();Editor(root,args.project);root.mainloop()


if __name__=='__main__':main()
