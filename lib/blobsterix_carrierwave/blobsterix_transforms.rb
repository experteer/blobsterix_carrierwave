# encoding: utf-8
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
  def raw_image(e)
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
  def strip(e)
    {
      :method => "strip",
      :args => ""
    }
  end
end