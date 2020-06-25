require 'pry'
class Student
attr_accessor :name, :grade
attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
        SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
    SQL

    DB[:conn].execute(sql)

  end

  def self.create(some_hash)
    new_student_name = ""
    new_student_grade = ""
    some_hash.each do |key, value|
    if key == :name
      new_student_name = value
    elsif key == :grade
      new_student_grade = value
    end
    end
    new_student = Student.new(new_student_name, new_student_grade)
    new_student.save
    return new_student
  end


end
