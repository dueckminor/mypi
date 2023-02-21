from .color import Color

c = Color()

class Powerline:
    def __init__(self):
        self.active = False
        self.fg = None
        self.bg = None
        
        pass
        
    def __enter__(self):
        return self
    
    def __exit__(self ,type, value, traceback):
        if self.fg or self.bg:
            print(" ",end="")
            print(c.use(fg=self.bg),end="")
            print("\033[49m\uE0B0",end="")
            print(c.reset())
        return False
    
    def segment(self, fg=None, bg=None, text=None):
        if self.active:
            if self.bg == bg or not bg:
                print(f" \uE0B1",end="")
            else:
                print(f" {c.use(fg=self.bg,bg=bg)}\uE0B0",end="")
        if not text: text=""
        print(f"{c.use(fg=fg,bg=bg)} {text}",end="")
        self.fg = fg
        self.bg = bg
        self.active = True
        
    def blue_segment(self, text=None):
        self.segment(bg=c.rgb6(1,1,5),fg=c.rgb6(5,5,0),text=text)
    def grey_segment(self, text=None):
        self.segment(bg=c.rgb6(2,2,2),fg=c.rgb6(5,5,5),text=text)