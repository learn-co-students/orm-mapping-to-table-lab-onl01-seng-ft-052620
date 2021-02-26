class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE IF EXISTS students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    # sql method last_insert_rowid()
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students") [0][0]
    ##ENOCH'S METHOD
      # saved_data = DB[:conn]execute("SELECT * FROM students WHERE name = ?", self.name)
    ## many students could have the same name...
      # @id = saved_data[0][0]
    #####
  end

  def self.create(name:, grade:)
    self.new(name, grade).tap{|student| student.save}
  end


end
