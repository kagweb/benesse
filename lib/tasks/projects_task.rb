class Tasks::ProjectsTask
  def self.create
    puts "=== Start Tasks::ProjectsTask ==="
    set_numbers
    puts 'Save? (Y/n)'

    while line = gets
      exit if /exit/ =~ line
      exit if /^n$/ =~ line
      break if /^Y$/ =~ line
    end

    set_numbers false
    puts "\e[32mSaved!\e[m"
  end

  def self.set_numbers dry_run = true
    Project.order(:created_at).all.group_by{|p| p.created_date }.each do |date, projects|
      i = 1
      puts "■ #{date}" if dry_run

      projects.each do |project|
        project.number = "#{project.created_date.strftime('%y')}#{project.created_date.strftime('%m')}#{project.created_date.strftime('%d')}#{format '%03d', i}"
        project.save unless dry_run
        i += 1
        puts " - #{project.name} : #{project.number}" if dry_run
      end

      puts '' if dry_run
    end
  end
end
