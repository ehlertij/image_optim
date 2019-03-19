require 'image_optim/worker'
require 'image_optim/option_helpers'

class ImageOptim
  class Worker
    # https://developers.google.com/speed/webp/docs/cwebp
    class Cwebp < Worker
      COMPRESSION_OPTION =
      option(:compression, 75, 'Compression factor: '\
          '`0` is least, '\
          '`100` is best') do |v|
        OptionHelpers.limit_with_range(v.to_i, 0..100)
      end

      LOSSLESS_OPTIONS =
      option(:lossless, true, 'Lossless option'){ |v| !!v }

      def run_order
        -4
      end

      def optimize(src, dst)
        args = %W[
          -q #{compression}
          -quiet
          #{src}
          --
          #{dst}
        ]
        args.unshift('-lossless') if lossless
        execute(:cwebp, *args) && optimized?(src, dst)
      end
    end
  end
end
