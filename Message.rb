class Message
  attr_accessor :show

  def initialize(window)
    @window = window
    @x, @y, @w, @h, @b = 0, 500, 960, 140, 5
    @black, @white = 0xff000000, 0xffffffff
    @font = Gosu::Font.new(@window, "Courier", 15)
    @text = ""
    @line_array = []
    @show_line = []
    @show_index
    @show = :false
    @next_line = false
    @print_text = ["",""]
    @p_index = [0,0]
    @waiting = false
  end

  def text=(new_text) #must be string!
    @text = new_text.clone
    @line_array.clear
    line_slicer(new_text)
    if @line_array.size > 1
      @show_line = @line_array[0..1]
      @next_line = true if @line_array.size >= 3
    else
      @show_line = @line_array.clone
    end
    @show_index = 0
    @show = :true
  end

  def line_slicer(new_text)
    while new_text.size >= 34
      l_index = new_text.slice(0..33).rindex(" ")
      @line_array << new_text.slice!(0..l_index)
    end
    @line_array << new_text
  end

  def interact
    # if @show_line.size > 1
    #   if @print_text[1].size < @show_line[1].size
    #     @print_text = @show_line.clone
    #   else
    #     move_line
    #   end
    # else
    #   if @print_text[0].size < @show_line[0].size
    #     @print_text = @show_line.clone
    #   else
    #     move_line
    #   end
    # end
    if !@waiting
      @print_text = @show_line.clone
    else
      move_line
    end
  end

  def move_line
    if @next_line
      @show_index += 2
      @show_line = @line_array[@show_index..@show_index + 1]
      @next_line = false if @line_array.size - @show_index <= 2
      reset_prints
    else
      @show = :false
    end
  end

  def fill_text
    fill_prints if Gosu::milliseconds / 50 % 2 == 0
    if @show_line.size > 1
      if @print_text[1].size < @show_line[1].size
        @waiting = false
      else
        @waiting = true
      end
    else
      if @print_text[0].size < @show_line[0].size
        @waiting = false
      else
        @waiting = true
      end
    end
  end

  def fill_prints
    if @print_text[0].size < @show_line[0].size
      @print_text[0] << @show_line[0][@p_index[0]]
      @p_index[0] += 1
    else
      if @show_line.size > 1
        if @print_text[1].size < @show_line[1].size
          @print_text[1] << @show_line[1][@p_index[1]]
          @p_index[1] += 1
        end
      end
    end
  end

  def reset_prints
    @p_index = [0,0]
    @print_text = ["",""]
  end

  def draw
    if @show == :true
      @window.draw_quad(@x, @y, @black, @x + @w, @y, @black, @x, @y + @h, @black, @x + @w, @y + @h, @black, 4) #black box
      @window.draw_quad(@x + @b, @y + @b, @white, @x + @w - @b, @y + @b, @white, @x + @b, @y + @h - @b, @white, @x + @w - @b, @y + @h - @b, @white, 5) # white box
      fill_text
      @print_text.each_with_index do |line, index|
        @font.draw("#{line}", @x + 35 , @y + 10 + (index * 64), 6, 4.0, 4.0, @black)
      end
      if @next_line && @waiting
        if Gosu::milliseconds / 200 % 4 <= 1
          @window.draw_triangle(@x + @w - 60, @y + @h - 30, @black, @x + @w - 40, @y + @h - 30, @black, @x + @w - 50, @y + @h - 13, @black, 7)
        end
      end
    else
      reset_prints
    end
  end
end