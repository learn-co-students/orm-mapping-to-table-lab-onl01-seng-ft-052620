class Student

  attr_accessor :name,:grade
  attr_reader :id

  @@all = []

  def initialize(name,grade)
    @name=name
    @grade=grade
    @id=nil
  end

  def self.create(params)
    student = Student.new(params[:name],params[:grade])
    student.save
    student
  end

  def save
    @@all << self

    sql = <<-SQL
    INSERT INTO students (name,grade)
    VALUES (?,?)
    SQL

    DB[:conn].execute(sql,self.name,self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end
  
end
