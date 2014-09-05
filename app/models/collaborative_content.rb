class CollaborativeContent
  class Cursor < Struct.new(:position, :color, :login)
    @@COLORS = ['blue', 'red', 'yellow', 'green']

    def initialize
      self.color = @@COLORS.shift
    end
  end

  class Version
    attr_reader :content

    def initialize content = ""
      @content = content
    end

    def insert position, text
      begin
        @content.insert position, text
      rescue IndexError
        puts "INDEX ERROR!".red
        @content += text
        @content
      end
      @content
    end

    def delete position, text
      @content.slice! position, text.length
      @content
    end

    def clone
      self.class.new @content.dup
    end
  end

  attr_reader :versions
  attr_reader :cursors

  def initialize content = ""
    @cursors = Hash.new { Cursor.new }
    @versions = []
  end

  def update_cursor uid, login, position
    @cursors[uid].position = position
    @cursors[uid].login = login
  end

  def do_modif method, position, text, version
    if version == @versions.count + 1
      puts "====================> begin STD #{@versions.count}".green
      version = @versions.last.try(:clone) || Version.new
      version.send(method, position, text)
      @versions << version
      puts "====================> end STD #{@versions.count}".green
      return true
    elsif version < @versions.count + 1
      puts "====================> Conflict!!!!!!!!!!!!!!!".red
      last_stable_version       = @versions[version - 2]
      conflict_version          = last_stable_version.clone.send(method, position, text)
      conflict_version_official = @versions.last

      p "~~~~~~~~~~~~>"
      p last_stable_version.content
      p conflict_version_official.content
      p conflict_version
      p "~~~~~~~~~~~~>"

      @versions[-1] = Version.new Merge3::three_way(last_stable_version.content, conflict_version_official.content, conflict_version)
      return :conflict
    else
      puts "====================> t'es dans le turfu par rapport a moi!!!!".red
    end
    false
  end

  def content
    @versions.last.try(:content) || ""
  end

  def dump_state
    {:content => self.content, :version => @versions.length, :cursors => @cursors}
  end
end