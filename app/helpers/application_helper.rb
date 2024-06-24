module ApplicationHelper
    def flash_class(level)
        case level
            when "notice" then "alert alert-info"
            when "success" then "alert alert-success"
            when "error" then "alert alert-error"
            when "alert" then "alert alert-danger"
            else "alert alert-info"
        end
    end

    def markdown_to_html(markdown_text)
        renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true)
        markdown = Redcarpet::Markdown.new(renderer, extensions = {
            autolink: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            lax_html_blocks: true,
            strikethrough: true,
            superscript: true
        })
        markdown.render(markdown_text).html_safe
    end

end
