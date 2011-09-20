class Object
  def try(*a, &b)
    if a.empty? && block_given?
      yield self
    elsif !a.empty? && !respond_to?(a.first)
      nil
    else
      __send__(*a, &b)
    end
  end
end