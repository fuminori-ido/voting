module StagesHelper
  def qrcode_tag(url)
    qr = ::RQRCode::QRCode.new(url)
    tag.div(class: 'w-full m-10') do
      qr.as_svg(
        viewbox:  '0 0 100 100'
      ).html_safe
    end
  end
end
