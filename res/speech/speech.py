#!/usr/bin/env python3

import speech_recognition as sr
from pynput.keyboard import Controller, Key
from pynput.keyboard import KeyCode
from pynotifier import Notification
from subprocess import run


keyboard = Controller()
r = sr.Recognizer()
mic = sr.Microphone()

def openHelp():
    run(['chromium', '~/.config/xmobar/speech/README.md'])

def closeWindow():
    """ Closes the currently open window"""
    with keyboard.pressed(Key.cmd, Key.shift):
        keyboard.press(KeyCode(81))
        keyboard.release(KeyCode(81))

def ancorWindow():
    """ Bring window back into tiled mode form floating mode"""
    with keyboard.pressed(Key.cmd):
        keyboard.press(KeyCode(84))
        keyboard.release(KeyCode(84))

def insertEnter():
    """ Inserts an enter/new line character"""
    keyboard.press(Key.enter)
    keyboard.release(Key.enter)

prefixCommand = "Thinkpad Befehl"

commands = [
    { "sentence": "Hilfe"
    , "info" :    "Öffnet das Hilfefenster mit Informationen zu allen Befehlen"
    , "command": openHelp },
    { "sentence": "schließen"
    , "info" :    "Schließt das fokussierte Fenster"
    , "command": closeWindow },
    { "sentence": "ausführen"
    , "info" :    "Tippt die Enter-Taste"
    , "command": insertEnter },
    { "sentence": "ankern"
    , "info" :    "Bringt ein Fenster zurück vom floating in den tiled modus"
    , "command": ancorWindow },
]

def checkForCommand(text, commands):
    """ Check if a command is found and execute it

        Return
        ------
        True if a matching command was found
    """
    if prefixCommand in text:
        for c in commands:
            if text == prefixCommand+" "+c["sentence"]:
                c["command"]()
                return True
    return False

def main():
    with mic as source:
        r.adjust_for_ambient_noise(source)
        Notification(
            title='Speech recognition',
            description='started',
            icon_path='~/.config/xmobar/speech/icon/recording.png',
            duration=3,
            urgency=Notification.URGENCY_LOW
        ).send()
        audio = r.listen(source)
    text = r.recognize_google(audio,language='de-DE')
    # finished recording -> Notification
    Notification(
            title='Speech recognition',
            description='finished',
            icon_path='~/.config/xmobar/speech/icon/finished.png',
            duration=5,
            urgency=Notification.URGENCY_LOW
    ).send()
    # COPY to clipboard
    # out = subprocess.Popen(['echo',text], stdout=subprocess.PIPE)
    # subprocess.Popen(['xclip','-selection','clipboard'], stdin=out.stdout)
    # CHECK the text for commands to execute
    if not checkForCommand(text, commands):
        # WRITE each detected letter using the keyboard
        for letter in text:
            keyboard.press(letter)

if __name__ == '__main__':
    main()
