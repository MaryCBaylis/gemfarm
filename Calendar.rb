class Calendar
  attr_reader :day

  def initialize(window)
    @window = window
    @day = 1
  end

  def day_pass
    if @day != 30
      @day += 1
      Tile.all_crops.each { |crop| crop.day_pass }
      @window.player.day_pass
      @window.sounds.day_pass(@day)
      @window.effect(:fade_in)
      @window.show_message("Another day has passed.")
    else
      @day = 1
      @window.show_message("Market day came and went.")
    end
  end
end