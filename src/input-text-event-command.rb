#==============================================================================
# ** Input Text Event Command
#------------------------------------------------------------------------------
# Wachunga
# Version 2.0
# 2006-05-20
# See https://github.com/wachunga/rmxp-input-text for details
#==============================================================================
  
#------------------------------------------------------------------------------
# * SDK Log Script
#------------------------------------------------------------------------------
SDK.log('Input Text Event Command', 'Wachunga', 2.0, '2006-05-20')

if not SDK.state('Keyboard Input')
  p 'Keyboard Input script not found'
  SDK.disable("Input Text Event Command")
  p 'Input Text Event Command script disabled'
end

#------------------------------------------------------------------------------
# * Begin SDK Enable Test
#------------------------------------------------------------------------------
if SDK.state('Input Text Event Command') == true

#------------------------------------------------------------------------------
# configurable sound mode
# 0 - no extra sounds
# 1 - typing and deleting sounds
$input_text_sound_mode = 1
#------------------------------------------------------------------------------

module Keyboard
  @lock = []
  Del = 46
  Tilde = 192
  Forwardslash = 220
  Ctrl = 17
  Capslock = 20
  End = 35
  Home = 36
  Left = 37
  Right = 39

  # Note: original Numberpad constants in Keyboard Input Module are off
  Numpad = {}
  Numpad[0] = 96
  Numpad[1] = 97
  Numpad[2] = 98
  Numpad[3] = 99
  Numpad[4] = 100
  Numpad[5] = 101
  Numpad[6] = 102
  Numpad[7] = 103
  Numpad[8] = 104
  Numpad[9] = 105

  # trick to alias module method
  class << self
    alias wachunga_itec_Keyboard_update update
  end

  def Keyboard.testlock(key)
    State.call(key) & 0x01 == 1
  end
  
  def Keyboard.update
    wachunga_itec_Keyboard_update
    @lock.push(Keyboard::Capslock) if Keyboard.testlock(Keyboard::Capslock)
    @keys.push(Keyboard::Del) if Keyboard.testkey(Keyboard::Del)
    @keys.push(Keyboard::Tilde) if Keyboard.testkey(Keyboard::Tilde)
    if Keyboard.testkey(Keyboard::Forwardslash)
      @keys.push(Keyboard::Forwardslash)
    end
    @keys.push(Keyboard::Ctrl) if Keyboard.testkey(Keyboard::Ctrl)
    @keys.push(Keyboard::Capslock) if Keyboard.testkey(Keyboard::Capslock)
    @keys.push(Keyboard::End) if Keyboard.testkey(Keyboard::End)
    @keys.push(Keyboard::Home) if Keyboard.testkey(Keyboard::Home)
    @keys.push(Keyboard::Left) if Keyboard.testkey(Keyboard::Left)
    @keys.push(Keyboard::Right) if Keyboard.testkey(Keyboard::Right)
    for key in Keyboard::Numpad.values
      @keys.push(key) if Keyboard.testkey(key)
    end
    @pressed.push(Keyboard::Del) if Keyboard.getstate(Keyboard::Del)
    @pressed.push(Keyboard::Tilde) if Keyboard.getstate(Keyboard::Tilde)
    if Keyboard.getstate(Keyboard::Forwardslash)
      @pressed.push(Keyboard::Forwardslash) 
    end
    @pressed.push(Keyboard::Ctrl) if Keyboard.getstate(Keyboard::Ctrl)
    @pressed.push(Keyboard::Capslock) if Keyboard.getstate(Keyboard::Capslock)
    @pressed.push(Keyboard::End) if Keyboard.getstate(Keyboard::End)
    @pressed.push(Keyboard::Home) if Keyboard.getstate(Keyboard::Home)
    @pressed.push(Keyboard::Left) if Keyboard.getstate(Keyboard::Left)
    @pressed.push(Keyboard::Right) if Keyboard.getstate(Keyboard::Right)
    for key in Keyboard::Numpad.values
      @pressed.push(key) if Keyboard.getstate(key)
    end
  end
  
  def Keyboard.lock?(key)
    return true if @lock.include?(key)
    return false
  end
end

#------------------------------------------------------------------------------

class Game_Temp
  
  attr_accessor :text_input_start       # opening line
  attr_accessor :text_input_variable_id # variable ID
  attr_accessor :text_input_chars_max   # max chars

  alias input_text_init initialize
  def initialize
    input_text_init
    @text_input_start = 99
    @text_input_variable_id = 0
    @text_input_chars_max = 0
  end
end

#------------------------------------------------------------------------------

class Window_Message < Window_Selectable

 alias input_text_dispose dispose
 def dispose
   if @input_text_window != nil
     @input_text_window.dispose
   end
   input_text_dispose
 end
 
 alias input_text_tm terminate_message
 def terminate_message
   input_text_tm
   $game_temp.text_input_start = 99
   $game_temp.text_input_variable_id = 0
   $game_temp.text_input_chars_max = 0
 end

 alias input_text_refresh refresh
 def refresh
   input_text_refresh
   if $game_temp.text_input_variable_id > 0
     chars_max = $game_temp.text_input_chars_max
     text = $game_variables[$game_temp.text_input_variable_id]
     if text == 0 then text = nil end
     # create the window
     @input_text_window = Window_InputText.new(chars_max, text)
     @input_text_window.x = self.x + 4
     @input_text_window.y = self.y + $game_temp.text_input_start * 32
   end
 end

 def update
   super
   if @fade_in
     self.contents_opacity += 24
     if @input_number_window != nil
       @input_number_window.contents_opacity += 24
     end
#------------------------------------------------------------------------------
# Begin Input Text Event Command Edit
#------------------------------------------------------------------------------
     if @input_text_window != nil
       @input_text_window.contents_opacity += 24
     end
#------------------------------------------------------------------------------
# End Input Text Event Command Edit
#------------------------------------------------------------------------------
     if self.contents_opacity == 255
       @fade_in = false
     end
     return
   end
   if @input_number_window != nil
     @input_number_window.update
     if Input.trigger?(Input::C)
       $game_system.se_play($data_system.decision_se)
       $game_variables[$game_temp.num_input_variable_id] =
         @input_number_window.number
       $game_map.need_refresh = true
       @input_number_window.dispose
       @input_number_window = nil
       terminate_message
     end
     return
   end
#------------------------------------------------------------------------------
# Begin Input Text Event Command Edit
#------------------------------------------------------------------------------
   if @input_text_window != nil
     @input_text_window.update
     if Keyboard.trigger?(Keyboard::Enter)
       $game_system.se_play($data_system.decision_se)
       # save the input text in the hash
       $game_variables[$game_temp.text_input_variable_id] =
         @input_text_window.text.to_s.strip
       $game_map.need_refresh = true
       @input_text_window.dispose
       @input_text_window = nil
       terminate_message
     end
     return
   end
#------------------------------------------------------------------------------
# End Input Text Event Command Edit
#------------------------------------------------------------------------------
   if @contents_showing
     if $game_temp.choice_max == 0
       self.pause = true
     end
     if Input.trigger?(Input::B)
       if $game_temp.choice_max > 0 and $game_temp.choice_cancel_type > 0
         $game_system.se_play($data_system.cancel_se)
         $game_temp.choice_proc.call($game_temp.choice_cancel_type - 1)
         terminate_message
       end
     end
     if Input.trigger?(Input::C)
       if $game_temp.choice_max > 0
         $game_system.se_play($data_system.decision_se)
         $game_temp.choice_proc.call(self.index)
       end
       terminate_message
     end
     return
   end
   if @fade_out == false and $game_temp.message_text != nil
     @contents_showing = true
     $game_temp.message_window_showing = true
     reset_window
     refresh
     Graphics.frame_reset
     self.visible = true
     self.contents_opacity = 0
     if @input_number_window != nil
       @input_number_window.contents_opacity = 0
     end
#------------------------------------------------------------------------------
# Begin Input Text Event Command Edit
#------------------------------------------------------------------------------
     if @input_text_window != nil
       @input_text_window.contents_opacity = 0
     end
#------------------------------------------------------------------------------
# End Input Text Event Command Edit
#------------------------------------------------------------------------------
     @fade_in = true
     return
   end
   if self.visible
     @fade_out = true
     self.opacity -= 48
     if self.opacity == 0
       self.visible = false
       @fade_out = false
       $game_temp.message_window_showing = false
     end
     return
   end
 end
 
end

#------------------------------------------------------------------------------

class Interpreter

  # Show message
  def command_101
   if $game_temp.message_text != nil
     return false
   end
   @message_waiting = true
   $game_temp.message_proc = Proc.new { @message_waiting = false }
   $game_temp.message_text = @list[@index].parameters[0] + "\n"
   line_count = 1
   loop do
     if @list[@index+1].code == 401
       $game_temp.message_text += @list[@index+1].parameters[0] + "\n"
       line_count += 1
     else
       if @list[@index+1].code == 102
         if @list[@index+1].parameters[0].size <= 4 - line_count
           @index += 1
           $game_temp.choice_start = line_count
           setup_choices(@list[@index].parameters)
         end
       elsif @list[@index+1].code == 103
         if line_count < 4
           @index += 1
           $game_temp.num_input_start = line_count
           $game_temp.num_input_variable_id = @list[@index].parameters[0]
           $game_temp.num_input_digits_max = @list[@index].parameters[1]
         end
#------------------------------------------------------------------------------
# Begin Input Text Event Command Edit
#------------------------------------------------------------------------------
       elsif @list[@index+1].code == 355 # call script
         if line_count < 4 and
             @list[@index+1].parameters[0].include?('input_text')
           @index += 1
           $game_temp.text_input_start = line_count
           command_355
         end
#------------------------------------------------------------------------------
# End Input Text Event Command Edit
#------------------------------------------------------------------------------
       end
       return true
     end
     @index += 1
   end
  end
  
  #----------------------------------------------------------------------------
  # * Input Text (to be called by Script... event command)
  #     id        : ID of the variable in which to store the input text, e.g. 1
  #                   Note: leading 0's will cause problems, e.g. 008
  #     chars_max : (optional) max number of characters to be allowed, e.g. 10
  #                   Note: leave blank or set as 0 for no limit
  #     default   : (optional) default text to appear, e.g. 'Bob'
  #----------------------------------------------------------------------------
  def input_text(id, chars_max=0, default=nil)
   # check to see if in own window
   if $game_temp.text_input_start == 99
     # only do below if in its own window
     if $game_temp.message_text != nil
       return false
     end
     @message_waiting = true
     $game_temp.message_proc = Proc.new { @message_waiting = false }
     $game_temp.message_text = ''
     $game_temp.text_input_start = 0
   end
   $game_temp.text_input_variable_id = id
   $game_temp.text_input_chars_max = chars_max
   $game_variables[$game_temp.text_input_variable_id] = default
   return true     
  end

end

#------------------------------------------------------------------------------

class Scene_Map
  
  def main_loop
    # Update game screen
    Graphics.update
    # Update input information
#------------------------------------------------------------------------------
# Start Input Text Event Command Edit
#------------------------------------------------------------------------------
    Keyboard.update # can't alias here: Input.update ruins GetAsyncKeyState
#------------------------------------------------------------------------------
# End Input Text Event Command Edit
#------------------------------------------------------------------------------
    Input.update
    # Frame update
    update
  end
end

#------------------------------------------------------------------------------

#==============================================================================
# ** Window_InputText
#------------------------------------------------------------------------------
#  This window is for inputting text and is used within the
#  message window.
#==============================================================================
class Window_InputText < Window_Base
 
  attr_reader :text

  # maximum length of input text (in pixels)
  MAX_WIDTH = 448
  CURSOR_WIDTH = 2
 
  #----------------------------------------------------------------------------
  # * Object Initialization
  #     chars_max : max number of characters (0 is infinite)
  #     default   : (optional) default text to appear, e.g. 'Bob'
  #----------------------------------------------------------------------------
  def initialize(chars_max=0, default=nil)
   @chars_max = (chars_max == 0 ? 1000 : chars_max)
   @char_widths = calculate_char_widths
   @cursor_width = CURSOR_WIDTH
   super(0, 0, 480, 64)
   self.contents = Bitmap.new(width - 32, height - 32)
   self.z += 9999
   self.opacity = 0
   @cursor_x = 0
   @text = Array.new
   if default != nil
     for i in 0...default.size
       @text[i] = default[i].chr
       @cursor_x += @char_widths[@text[i]]
     end
     @index = @text.size
   else
     @index = 0
   end
   @last_text = @text.clone
   refresh
   update_cursor_rect
  end
  
  #----------------------------------------------------------------------------
  # * Character Width Calculation
  #----------------------------------------------------------------------------
  def calculate_char_widths
    widths = {}
    dummy_bitmap = Bitmap.new(32, 32)
    for i in 32..126 # ASCII values
      widths[i.chr] = dummy_bitmap.text_size(i.chr).width
    end
    dummy_bitmap.dispose
    # text_size() is inaccurate in some cases, so manually adjust
    widths['f'] += 2
    widths['A'] += 1
    widths['a'] += 1
    widths['V'] += 1
    widths['v'] += 1
    widths['M'] += 1
    widths['W'] += 1
    widths['w'] += 1
    widths['y'] += 1
    widths['/'] += 1
    widths['\\'] += 1
    return widths
  end
 
  #----------------------------------------------------------------------------
  # * Cursor Rectangle Update
  #----------------------------------------------------------------------------
  def update_cursor_rect
   self.cursor_rect.set(@cursor_x, 0, @cursor_width, 32)
  end
  
  #----------------------------------------------------------------------------
  # * Character Addition
  #     character - character to be displayed
  #----------------------------------------------------------------------------
  def add(character)
    if @total_width + @char_widths[character] <= MAX_WIDTH and
        @text.size < @chars_max
      if $input_text_sound_mode == 1
        $game_system.se_play($data_system.cursor_se)
      end
      @text.size.downto(@index+1) do |i|
        @text[i] = @text[i-1]
      end
      @text[@index] = character
      @index += 1
      @cursor_x += @char_widths[character]
    else
      $game_system.se_play($data_system.cancel_se)
    end
  end
  
  #----------------------------------------------------------------------------
  # * Frame Update
  #----------------------------------------------------------------------------
  def update
    super
    if Keyboard.trigger?(Keyboard::Back) # backspace key
      if @index == 0
        $game_system.se_play($data_system.cancel_se)
      else
        if $input_text_sound_mode == 1
          $game_system.se_play($data_system.cursor_se)
        end
        @index -= 1
        @cursor_x -= @char_widths[@text[@index]]
        @text[@index] = nil
        @text.compact!
      end
    end
    if Keyboard.trigger?(Keyboard::Del) # delete key
      if @index == @text.size
        $game_system.se_play($data_system.cancel_se)
      else
        if $input_text_sound_mode == 1
          $game_system.se_play($data_system.cursor_se)
        end
        @text[@index] = nil
        @text.compact!
      end
    end
    if Keyboard.trigger?(Keyboard::End)
      @index = @text.size
      @cursor_x = @total_width
      update_cursor_rect
    end
    if Keyboard.trigger?(Keyboard::Home)
      @index = @cursor_x = 0
      update_cursor_rect
    end
    if Keyboard.trigger?(Keyboard::Right)
      if @index < @text.size
        if not Keyboard.pressed?(Keyboard::Ctrl)
          # regular cursor movement (one letter)
          @index += 1
          @cursor_x += @char_widths[@text[@index-1]]
        else
          # Ctrl-cursor movement (next word)
          # scan right until beginning of new word found
          space_found = false
          target = -1
          x = 0
          for i in @index...@text.size
            x += @char_widths[@text[i]]
            if space_found == false
              if @text[i] == ' '
                space_found = true
              end
            else
              if @text[i] != ' '
                target = i
                x -= @char_widths[@text[i]]
                break
              end
            end
          end
          if target != -1
            # a new word was found
            @index = target
            @cursor_x += x
          else
            # jump to end of input
            @index = @text.size
            @cursor_x = @total_width
          end
        end
        update_cursor_rect
      end
    end
    if Keyboard.trigger?(Keyboard::Left)
      if @index != 0
        if not Keyboard.pressed?(Keyboard::Ctrl)
          # regular cursor movement (one letter)
          @index -= 1
          if @index == 0 then @cursor_x = 0
          else
            @cursor_x -= @char_widths[@text[@index]]
          end
        else
          # Ctrl-cursor movement (next word)
          # scan left until beginning of new word found
          non_space_found = false
          target = -1
          x = 0
          (@index-1).downto(0) do |i|
            x += @char_widths[@text[i]]
            if non_space_found == false
              if @text[i] != ' '
                non_space_found = true
              end
            else
              if @text[i] == ' '
                target = i+1
                x -= @char_widths[@text[i]]
                break
              end
            end
          end
          if target != -1
            # a new word was found
            @index = target
            @cursor_x -= x
          else
            # jump to start of input
            @index = 0
            @cursor_x = 0
          end
        end
        update_cursor_rect
      end
    end
    # Letters...
    for key in Keyboard::Letters.values
      if Keyboard.trigger?(key)
        if ( Keyboard.lock?(Keyboard::Capslock) and
             !Keyboard.pressed?(Keyboard::Shift) ) or
           ( !Keyboard.lock?(Keyboard::Capslock) and
             Keyboard.pressed?(Keyboard::Shift) )
          add(key.chr.upcase)
        else add(key.chr.downcase)
        end
      end
    end
    # Numbers...
    for key in Keyboard::Numberkeys.values
      if Keyboard.trigger?(key)
        if Keyboard.pressed?(Keyboard::Shift)
          case key
            when Keyboard::Numberkeys[0] then add(')')
            when Keyboard::Numberkeys[1] then add('!')
            when Keyboard::Numberkeys[2] then add('@')
            when Keyboard::Numberkeys[3] then add('#')
            when Keyboard::Numberkeys[4] then add('$')
            when Keyboard::Numberkeys[5] then add('%')
            when Keyboard::Numberkeys[6] then add('^')
            when Keyboard::Numberkeys[7] then add('&')
            when Keyboard::Numberkeys[8] then add('*')
            when Keyboard::Numberkeys[9] then add('(')
          end
        else
          add(key.chr)
        end
      end
    end
    # Numpad...
    for key in Keyboard::Numpad.values
      if Keyboard.trigger?(key)
        case key
          when Keyboard::Numpad[0] then add('0')
          when Keyboard::Numpad[1] then add('1')
          when Keyboard::Numpad[2] then add('2')
          when Keyboard::Numpad[3] then add('3')
          when Keyboard::Numpad[4] then add('4')
          when Keyboard::Numpad[5] then add('5')
          when Keyboard::Numpad[6] then add('6')
          when Keyboard::Numpad[7] then add('7')
          when Keyboard::Numpad[8] then add('8')
          when Keyboard::Numpad[9] then add('9')
        end
      end
    end
    if Keyboard.trigger?(Keyboard::Space)
      add(' ')
    end
    if Keyboard.trigger?(Keyboard::Tilde)
      if Keyboard.pressed?(Keyboard::Shift) then add('~')
      else add('`') end
    end
    if Keyboard.trigger?(Keyboard::Lb)
      if Keyboard.pressed?(Keyboard::Shift) then add('{')
      else add('[') end
    end
    if Keyboard.trigger?(Keyboard::Rb)
      if Keyboard.pressed?(Keyboard::Shift) then add('}')
      else add(']') end
    end
    if Keyboard.trigger?(Keyboard::Comma)
      if Keyboard.pressed?(Keyboard::Shift) then add('<')
      else add(',') end
    end
    if Keyboard.trigger?(Keyboard::Dot)
      if Keyboard.pressed?(Keyboard::Shift) then add('>')
      else add('.') end
    end
    if Keyboard.trigger?(Keyboard::Backslash)
      if Keyboard.pressed?(Keyboard::Shift) then add('?')
      else add('/') end
    end
    if Keyboard.trigger?(Keyboard::Forwardslash)
      if Keyboard.pressed?(Keyboard::Shift) then add('|')
      else add("\\") end
    end
    if Keyboard.trigger?(Keyboard::Collon)
      if Keyboard.pressed?(Keyboard::Shift) then add(':')
      else add(';') end
    end
    if Keyboard.trigger?(Keyboard::Quote)
      if Keyboard.pressed?(Keyboard::Shift) then add('"')
      else add("'") end
    end
    if Keyboard.trigger?(Keyboard::Equal)
      if Keyboard.pressed?(Keyboard::Shift) then add('+')
      else add("=") end
    end
    if Keyboard.trigger?(Keyboard::Underscore)
      if Keyboard.pressed?(Keyboard::Shift) then add('_')
      else add("-") end
    end
    if (@text <=> @last_text) != 0
      @last_text = @text.clone
      refresh
    end
  end

  #----------------------------------------------------------------------------
  # * Refresh
  #----------------------------------------------------------------------------
  def refresh
   self.contents.clear
   x = 0
   for i in 0...@text.size
     width = @char_widths[@text[i]]
     self.contents.draw_text(x, 0, width, 32, @text[i], 1)
     x += width
   end
   @total_width = x
   update_cursor_rect
  end

end

#------------------------------------------------------------------------------
# * End SDK Enable Test
#------------------------------------------------------------------------------
end
