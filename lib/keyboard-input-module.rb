#==============================================================================
# ** Keyboard Input Module
#==============================================================================
# Near Fantastica
# Version 5
# 29.11.05
#==============================================================================
# The Keyboard Input Module is designed to function as the default Input module
# dose. It is better then other methods keyboard input because as a key is 
# tested it is not removed form the list. so you can test the same key multiple
# times the same loop.
#==============================================================================

#------------------------------------------------------------------------------
# * SDK Log Script
#------------------------------------------------------------------------------
SDK.log("Keyboard Input", "Near Fantastica", 5, "29.11.05")

#------------------------------------------------------------------------------
# * Begin SDK Enable Test
#------------------------------------------------------------------------------
if SDK.state("Keyboard Input") == true
  
  module Keyboard
    #--------------------------------------------------------------------------
    @keys = []
    @pressed = []
    Mouse_Left = 1
    Mouse_Right = 2
    Back= 8
    Tab = 9
    Enter = 13
    Shift = 16
    Ctrl = 17
    Alt = 18
    Esc = 27
    Space = 32
    Numberkeys = {}
    Numberkeys[0] = 48
    Numberkeys[1] = 49
    Numberkeys[2] = 50
    Numberkeys[3] = 51
    Numberkeys[4] = 52
    Numberkeys[5] = 53
    Numberkeys[6] = 54
    Numberkeys[7] = 55
    Numberkeys[8] = 56
    Numberkeys[9] = 57
    Numberpad = {}
    Numberpad[0] = 45
    Numberpad[1] = 35
    Numberpad[2] = 40
    Numberpad[3] = 34
    Numberpad[4] = 37
    Numberpad[5] = 12
    Numberpad[6] = 39
    Numberpad[7] = 36
    Numberpad[8] = 38
    Numberpad[9] = 33
    Letters = {}
    Letters["A"] = 65
    Letters["B"] = 66
    Letters["C"] = 67
    Letters["D"] = 68
    Letters["E"] = 69
    Letters["F"] = 70
    Letters["G"] = 71
    Letters["H"] = 72
    Letters["I"] = 73
    Letters["J"] = 74
    Letters["K"] = 75
    Letters["L"] = 76
    Letters["M"] = 77
    Letters["N"] = 78
    Letters["O"] = 79
    Letters["P"] = 80
    Letters["Q"] = 81
    Letters["R"] = 82
    Letters["S"] = 83
    Letters["T"] = 84
    Letters["U"] = 85
    Letters["V"] = 86
    Letters["W"] = 87
    Letters["X"] = 88
    Letters["Y"] = 89
    Letters["Z"] = 90
    Fkeys = {}
    Fkeys[1] = 112
    Fkeys[2] = 113
    Fkeys[3] = 114
    Fkeys[4] = 115
    Fkeys[5] = 116
    Fkeys[6] = 117
    Fkeys[7] = 118
    Fkeys[8] = 119
    Fkeys[9] = 120
    Fkeys[10] = 121
    Fkeys[11] = 122
    Fkeys[12] = 123
    Collon = 186
    Equal = 187
    Comma = 188
    Underscore = 189
    Dot = 190
    Backslash = 191
    Lb = 219
    Rb = 221
    Quote = 222
    State = Win32API.new("user32","GetKeyState",['i'],'i')
    Key = Win32API.new("user32","GetAsyncKeyState",['i'],'i')
    #--------------------------------------------------------------------------  
    def Keyboard.getstate(key)
      return true unless State.call(key).between?(0, 1)
      return false
    end
    #--------------------------------------------------------------------------
    def Keyboard.testkey(key)
      Key.call(key) & 0x01 == 1
    end
    #--------------------------------------------------------------------------
    def Keyboard.update
      @keys = []
      @keys.push(Keyboard::Mouse_Left) if Keyboard.testkey(Keyboard::Mouse_Left)
      @keys.push(Keyboard::Mouse_Right) if Keyboard.testkey(Keyboard::Mouse_Right)
      @keys.push(Keyboard::Back) if Keyboard.testkey(Keyboard::Back)
      @keys.push(Keyboard::Tab) if Keyboard.testkey(Keyboard::Tab)
      @keys.push(Keyboard::Enter) if Keyboard.testkey(Keyboard::Enter)
      @keys.push(Keyboard::Shift) if Keyboard.testkey(Keyboard::Shift)
      @keys.push(Keyboard::Ctrl) if Keyboard.testkey(Keyboard::Ctrl)
      @keys.push(Keyboard::Alt) if Keyboard.testkey(Keyboard::Alt)
      @keys.push(Keyboard::Esc) if Keyboard.testkey(Keyboard::Esc)
      @keys.push(Keyboard::Space) if Keyboard.testkey(Keyboard::Space)
      for key in Keyboard::Numberkeys.values
        @keys.push(key) if Keyboard.testkey(key)
      end
      for key in Keyboard::Numberpad.values
        @keys.push(key) if Keyboard.testkey(key)
      end
      for key in Keyboard::Letters.values
        @keys.push(key) if Keyboard.testkey(key)
      end
      for key in Keyboard::Fkeys.values
        @keys.push(key) if Keyboard.testkey(key)
      end
      @keys.push(Keyboard::Collon) if Keyboard.testkey(Keyboard::Collon)
      @keys.push(Keyboard::Equal) if Keyboard.testkey(Keyboard::Equal)
      @keys.push(Keyboard::Comma) if Keyboard.testkey(Keyboard::Comma)
      @keys.push(Keyboard::Underscore) if Keyboard.testkey(Keyboard::Underscore)
      @keys.push(Keyboard::Dot) if Keyboard.testkey(Keyboard::Dot)
      @keys.push(Keyboard::Backslash) if Keyboard.testkey(Keyboard::Backslash)
      @keys.push(Keyboard::Lb) if Keyboard.testkey(Keyboard::Lb)
      @keys.push(Keyboard::Rb) if Keyboard.testkey(Keyboard::Rb)
      @keys.push(Keyboard::Quote) if Keyboard.testkey(Keyboard::Quote)
      @pressed = []
      @pressed.push(Keyboard::Mouse_Left) if Keyboard.getstate(Keyboard::Mouse_Left)
      @pressed.push(Keyboard::Mouse_Right) if Keyboard.getstate(Keyboard::Mouse_Right)
      @pressed.push(Keyboard::Back) if Keyboard.getstate(Keyboard::Back)
      @pressed.push(Keyboard::Tab) if Keyboard.getstate(Keyboard::Tab)
      @pressed.push(Keyboard::Enter) if Keyboard.getstate(Keyboard::Enter)
      @pressed.push(Keyboard::Shift) if Keyboard.getstate(Keyboard::Shift)
      @pressed.push(Keyboard::Ctrl) if Keyboard.getstate(Keyboard::Ctrl)
      @pressed.push(Keyboard::Alt) if Keyboard.getstate(Keyboard::Alt)
      @pressed.push(Keyboard::Esc) if Keyboard.getstate(Keyboard::Esc)
      @pressed.push(Keyboard::Space) if Keyboard.getstate(Keyboard::Space)
      for key in Keyboard::Numberkeys.values
        @pressed.push(key) if Keyboard.getstate(key)
      end
      for key in Keyboard::Numberpad.values
        @pressed.push(key) if Keyboard.getstate(key)
      end
      for key in Keyboard::Letters.values
        @pressed.push(key) if Keyboard.getstate(key)
      end
      for key in Keyboard::Fkeys.values
        @pressed.push(key) if Keyboard.getstate(key)
      end
      @pressed.push(Keyboard::Collon) if Keyboard.getstate(Keyboard::Collon)
      @pressed.push(Keyboard::Equal) if Keyboard.getstate(Keyboard::Equal)
      @pressed.push(Keyboard::Comma) if Keyboard.getstate(Keyboard::Comma)
      @pressed.push(Keyboard::Underscore) if Keyboard.getstate(Keyboard::Underscore)
      @pressed.push(Keyboard::Dot) if Keyboard.getstate(Keyboard::Dot)
      @pressed.push(Keyboard::Backslash) if Keyboard.getstate(Keyboard::Backslash)
      @pressed.push(Keyboard::Lb) if Keyboard.getstate(Keyboard::Lb)
      @pressed.push(Keyboard::Rb) if Keyboard.getstate(Keyboard::Rb)
      @pressed.push(Keyboard::Quote) if Keyboard.getstate(Keyboard::Quote)  
    end
    #--------------------------------------------------------------------------
    def Keyboard.trigger?(key)
      return true if @keys.include?(key)
      return false
    end
    #--------------------------------------------------------------------------
    def Keyboard.pressed?(key)
      return true if @pressed.include?(key)
      return false
    end
  end

#------------------------------------------------------------------------------
# * End SDK Enable Test
#------------------------------------------------------------------------------
end
