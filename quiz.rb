# encoding: utf-8

require 'yaml'

#stuff
$UNDERLINE = "\e[4m"
$GREEN = "\e[37m\e[42m"
$RED = "\e[37m\e[41m"
$RESET = "\e[0m"
#stuff
$config = YAML.load_file('config.yml')
$QDB = $config["QDB"]
$QuestionNumber = $config["QuestionNumber"]
$QuestionCount = 0
$questions = Hash.new
$showncorrect = Hash.new

if $QuestionNumber > $QDB.length
  puts "Error: QuestionNumber is larger than the number of questions in the configuration."
  exit
else
  system "clear"
end

def question
  $cmd = ""
  $QuestionCount += 1
  $currentID = $QDB.keys.sample
  $current = $QDB[$currentID]
  $QDB.delete($currentID)
  puts "Question ##{$QuestionCount} (ID ##{$currentID}): " + $current["question"]
  puts "A: " + $current["A"]
  puts "B: " + $current["B"]
  puts "C: " + $current["C"]
  puts "D: " + $current["D"]
  until $cmd.gsub(/^(a|b|c|d|show|swap)$/, "") != $cmd
    $cmd = gets.chomp.downcase
  end
  if $cmd.gsub(/^show$/, "") != $cmd
    puts "Correct answer: " + $GREEN + $current["correct"] + $RESET
    $showncorrect[$currentID] = true
    until $cmd.gsub(/^(a|b|c|d)$/, "") != $cmd
      $cmd = gets.chomp.downcase
    end
  end
  if $cmd.gsub(/^swap$/, "") != $cmd
    if !$showncorrect[$currentID]
      puts "Correct answer: " + $GREEN + $current["correct"] + $RESET
    end
    puts "Swapping question."
    $QuestionCount -= 1
    question()
  end
  if $cmd.gsub(/^(a|b|c|d)$/, "") != $cmd
    if !$showncorrect[$currentID]
      puts "Correct answer: " + $GREEN + $current["correct"] + $RESET
    end
    if $cmd.upcase == $current["correct"]
      puts "Your answer: " + $GREEN + $cmd.upcase + $RESET
    else
      puts "Your answer: " + $RED + $cmd.upcase + $RESET
      exit
    end
  end
end


puts "Welcome to Mquiz!"
puts "Type \"start\" to start the game."
puts "———————————————————————————————"
until $cmd == "start"
  $cmd = gets.chomp.downcase
end
until $QuestionCount == $QuestionNumber
  sleep 3
  question
end
exit
