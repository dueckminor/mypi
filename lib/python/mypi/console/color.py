from typing import Optional

class Color:
    def reset(self):
        return "\033[0m"
    
    def use(self, fg:Optional[str]=None, bg:Optional[str]=None) -> str:
        result = "\033["
        if fg:
            result += "38;"+fg
        if bg:
            if fg:
                result+=";"
            result += "48;"+bg
        result += 'm'
        return result
            
    def rgb6(self, r:int, g:int, b:int) -> str:
        val = "5;"+str(16 + 36 * r + 6 * g + b)
        return val
        