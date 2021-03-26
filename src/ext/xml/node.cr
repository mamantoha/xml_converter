class XML::Node
  # Get an array of all Element children.
  def elements
    children.select(&.element?)
  end

  # Get an array of all Text children.
  def texts
    children.select(&.text?)
  end

  # Evaluates to `true` if this element has at least one child Element.
  def has_elements? : Bool
    !elements.empty?
  end

  # Evaluates to `true` if this element has at least one Text child.
  def has_text? : Bool
    !texts.empty?
  end

  # Evaluates to `true` if this element has at least one attribute.
  def has_attributes? : Bool
    !attributes.empty?
  end
end
