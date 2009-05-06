methods_for :dialplan do
  def call_for_change
    CallForChange.new(self).start
  end
end

class CallForChange
  def initialize(call)
    @call = call
    reset_choice
  end
  
  def start
    3.times do
      say_menu
      collect_choice
      valid_choice? ? process_choice : speak('Sorry, try again')
      sleep 2
    end
  end

  def say_menu
    speak "Press 1 to hear the current national debt, 2 to hear the current unemployment, 3 to hear the President's radio address."
  end

  def collect_choice
    @choice = @call.input(1).to_i
  end

  def process_choice
    case @choice
    when 1
      speak "The current national debt is 11 trillion, 224 billion, 640 million, 490 thousand, 575 dollars and 03 cents.  Your share is $36,666.33."
    when 2
      # http://www.bls.gov/cps/
      speak "The current unemployment rate is 8.5%, up 0.4% this quarter.  In 2008, the U.S. median wage was $15 per hour or $32,390 per year."
    when 3
      @call.play 'presidents_radio_address'
    else
      speak "Sorry, please enter a valid choice."
    end
  end

  def valid_choice?
    @choice >= 1 and @choice <= 3
  end
  
  def reset_choice
    @choice = nil
  end

  def speak(phrase)
    # specify text-to-speech system and send as quoted phrase
    @call.execute 'swift', "\"#{phrase}\""
  end
end
