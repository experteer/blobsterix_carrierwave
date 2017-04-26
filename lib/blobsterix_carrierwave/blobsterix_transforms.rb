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
  def resizemax(args)
     args=[args].flatten
     width=args[0]
     height=args[1]
     {
      :method => "resizemax",
      :args => "#{width}x#{height}"
     }
  end

  def blur(args)
     args=[args].flatten
     radius=args[0]
     sigma=args[1]
     {
      :method => "blur",
      :args => "#{radius}x#{sigma}"
     }
  end

  # extent takes 3 params in a hash, :background, :gravity and :size
  #
  # size is mandatory, background
  #
  # @param [Hash] args
  # @option args [String] :size
  # @option args [String] :background  (defaults to "transparent")
  # @option args [String] :gravity (defaults to "center")
  def extent(args)
    # only allow gravity, background and size options
    args.delete_if do |key, value|
      !([:gravity, :background, :size].include?(key))
    end
    args[:gravity] = "center" unless args[:gravity]
    args[:background] = "transparent" unless args[:background]
    send = args.map{|key, value| "#{key}=#{value}"}.join(";") + ";"
    {
        :method => "extent",
        :args   => send
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
      :method => format.to_s,
      :args => option.to_s
    }
  end

  def apply(method, option = "")
    {
      :method => method.to_s,
      :args => option.to_s
    }
  end

  def strip(e)
    {
      :method => "strip",
      :args => ""
    }
  end
end
