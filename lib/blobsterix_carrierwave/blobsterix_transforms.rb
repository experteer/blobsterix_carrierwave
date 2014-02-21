module BlobsterixTransforms
  def scale(width, height = "")
    {
      :method => "resize",
      :args => "#{width}x#{height}"
    }
  end
  def rotate(angle)
    {
      :method => "rotate",
      :args => "#{angle}"
    }
  end
  def raw_image()
    {
      :method => "raw",
      :args => ""
    }
  end
  def set_format(format, option = "")
    {
      :method => format,
      :args => option
    }
  end
end