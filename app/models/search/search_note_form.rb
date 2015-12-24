class Search::SearchNoteForm < Search::Base
  
  attr_accessor :user_number_sum

  def search
    current_group.notes
  end
end
