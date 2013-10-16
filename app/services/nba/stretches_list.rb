module Nba
  class StretchesList
    def initialize(stretch_lines)
      @stretch_lines = stretch_lines
    end

    def compress_stretches
      stint = nil
      stints = []
      @stretch_lines.each do |line|
        if stint and line.start == stint.end
          stint.end = line.end
        else
          stint = Nba::Stint.new(line.start, line.end)
          stints << stint
        end
      end
      return stints
    end
  end
end
