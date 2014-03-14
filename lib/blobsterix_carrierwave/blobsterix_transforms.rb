# encoding: utf-8
module BlobsterixTransforms
  def resize(args)
     args=[args].flatten
     width=args[0]
     height=args[1]
     {
      :method => "resize",
      :args => "#{width}x#{height}"
     }
  end
  def resize_max(args)
     args=[args].flatten
     width=args[0]
     height=args[1]
     {
      :method => "resize-max",
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