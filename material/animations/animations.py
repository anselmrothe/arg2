#!/usr/bin/python3
import tkinter as tk
import tkinter.ttk as ttk
import os

root = tk.Tk()

def ffplay(vid):
    os.system("ffplay -fs -autoexit " + vid)

def key(event):
    if event.char == "d": ffplay("video/jump\ AALL.mkv")
    if event.char == "r": ffplay("video/jump\ ALL.mkv")
    if event.char == "n": ffplay("video/jump\ AAL.mkv")
    if event.char == "s": ffplay("video/jump\ AL.mkv")
    if event.char == "a": ffplay("video/throw\ AALL.mkv")
    if event.char == "o": ffplay("video/throw\ ALL.mkv")
    if event.char == "e": ffplay("video/throw\ AAL.mkv")
    if event.char == "i": ffplay("video/throw\ AL.mkv")
    else: print(event.char)

canvas = tk.Canvas(root, width = 1920, height = 1080, background = "#000000")
canvas.focus_set()

canvas.bind("<Key>", key)
canvas.pack()

root.mainloop()
