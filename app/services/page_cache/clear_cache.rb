module PageCache
  class ClearCache
    class << self
      def clear
        count = 0
        files = []
        Dir.new("#{Rails.root}/public").each do |file|
          if (Nba::TEAMS.keys.any? {|team| team =~ /#{file.gsub(".html", "")}/ } and not (file == ".." or file == ".")) or file == "index.html"
            count += 1
            files << file
            File.delete("#{Rails.root}/public/#{file}")
          end
        end
        return [files, count]
      end
    end
  end
end
