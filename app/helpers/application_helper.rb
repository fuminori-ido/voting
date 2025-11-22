module ApplicationHelper
  def render_index_actions(rec)
    tag.td(align: 'right') do
      link_to(v_i18n('edit'), url_for(id: rec.id, action: 'edit'), class: "w-full sm:w-auto text-center rounded-md px-3.5 py-2.5 bg-gray-100 hover:bg-gray-50 inline-block font-medium mx-0.5") +
      tag.div(class: "sm:inline-block") do
        button_to(v_i18n('destroy'), rec, method: :delete, class: "w-full sm:w-auto rounded-md px-3.5 py-2.5 text-white bg-red-600 hover:bg-red-500 font-medium cursor-pointer mx-0.5", data: { turbo_confirm: "Are you sure?" })
      end
    end
  end

  def render_messages(rec)
    if rec.errors.any?
      tag.div(id: "error_explanation", class: "bg-red-50 text-red-500 px-3 py-2 font-medium rounded-md mt-3") do
        tag.h2(v_i18n('errors_occured', num: rec.errors.count)) +
        tag.ul(class: "list-disc ml-6") do
          rec.errors.each do |error|
            concat(tag.li(error.full_message))
          end
        end
      end
    end
  end

  def top_menu_link_to(model, label: nil)
    _controller_name  = model.model_name.route_key
    _label            = label || model.model_name.human
    if available_for?(_controller_name)
      link_to(_label, url_for(controller: _controller_name),
              class: "px-4 py-2 text-white font-semibold border-b-4 border-blue-700 hover:bg-blue-700 focus:outline-none tab-button")
    else
      ''
    end
  end

  def link_to_index(url)
    link_to(v_i18n('back_to_index'), url, class: "w-full sm:w-auto text-center mt-2 sm:mt-0 sm:ml-2 rounded-md px-3.5 py-2.5 bg-gray-100 hover:bg-gray-50 inline-block font-medium")
  end

  def v_number_field(f, rec, column)
    tag.div(class: "flex sm:items-center mb-6 flex-col sm:flex-row") do
      f.label(column,       class: 'block sm:w-1/4 font-bold sm:text-right mt-2 pr-4') +
      f.number_field(column,  class: [
                                "block sm:w-3/4 rounded-md border px-3 py-2 mt-2 w-full",
                                {
                                  "border-gray-400 focus:outline-blue-600": rec.errors[:name].none?,
                                  "border-red-400 focus:outline-red-600":   rec.errors[:name].any?
                                }])
    end
  end

  def v_text_field(f, rec, column)
    tag.div(class: "flex sm:items-center mb-6 flex-col sm:flex-row") do
      f.label(column,       class: 'block sm:w-1/4 font-bold sm:text-right mt-2 pr-4') +
      f.text_field(column,  class: [
                                "block sm:w-3/4 rounded-md border px-3 py-2 mt-2 w-full",
                                {
                                  "border-gray-400 focus:outline-blue-600": rec.errors[:name].none?,
                                  "border-red-400 focus:outline-red-600":   rec.errors[:name].any?
                                }])
    end
  end

  def v_file_field(f, rec, column)
    tag.div(class: "flex sm:items-center mb-6 flex-col sm:flex-row") do
      f.label(column,       class: 'block sm:w-1/4 font-bold sm:text-right mt-2 pr-4') +
      if rec.avatar.file.nil?
        ''
      else
        image_tag(thumb_candidate_path(rec))
      end +
      f.file_field(column,  class: [
                                "block sm:w-3/4 rounded-md border px-3 py-2 mt-2 w-full",
                                {
                                  "border-gray-400 focus:outline-blue-600": rec.errors[:name].none?,
                                  "border-red-400 focus:outline-red-600":   rec.errors[:name].any?
                                }])
    end
  end

  def v_select(f, rec, column, select_options)
    tag.div(class: "flex sm:items-center mb-6 flex-col sm:flex-row") do
      f.label(column, class: 'block sm:w-1/4 font-bold sm:text-right mt-2 pr-4') +
      f.select(column,
               select_options,
               {},
               {
                  class: [
                    "block sm:w-3/4 rounded-md border px-3 py-2 mt-2 w-full",
                    {
                      "border-gray-400 focus:outline-blue-600": rec.errors[:name].none?,
                      "border-red-400 focus:outline-red-600":   rec.errors[:name].any?
                    }
                  ]
               })
    end
  end

  def v_check_box(f, rec, column)
    tag.div(class: "flex sm:items-center mb-6 flex-col sm:flex-row") do
      tag.span('', class: 'block sm:w-1/4 font-bold sm:text-right mt-2 pr-4') +
      tag.div(class: 'block sm:w-3/4 mt-2 pr-4') do
        f.check_box(column,  class: [
                                  "w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded-sm focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600",
                                  {
                                    "border-gray-400 focus:outline-blue-600": rec.errors[:name].none?,
                                    "border-red-400 focus:outline-red-600":   rec.errors[:name].any?
                                  }]) +
        f.label(column, class: 'ms-2 font-medium text-gray-900 dark:text-gray-300')
      end
    end
  end

  def v_button_class
    %w{w-full sm:w-auto rounded-md px-3.5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white inline-block font-medium cursor-pointer}
  end

  def v_button_class_disabled
    %w{w-full sm:w-auto rounded-md px-3.5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white inline-block font-medium disabled:bg-gray-400}
  end
end
