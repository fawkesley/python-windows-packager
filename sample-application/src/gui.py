from Tkinter import Tk
import tkMessageBox

def show_message(message, title="message"):
    window = Tk()
    window.wm_withdraw()

    tkMessageBox.showinfo(title=title, message=message, parent=window)


