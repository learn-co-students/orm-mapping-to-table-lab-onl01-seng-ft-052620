class Student

  attr_reader :id, :name, :grade

  def initialize(name, grade, id=nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-sql
    CREATE TABLE students(
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    );
    sql
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-sql
    DROP TABLE students;
    sql
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-sql
    INSERT INTO students(name,grade)
    VALUES(?,?)
    sql
    DB[:conn].execute(sql,self.name,self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(hash)
    student_var = Student.new(hash[:name], hash[:grade])
    student_var.save
    student_var
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
end
