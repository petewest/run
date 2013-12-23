module PostsHelper
  def writeup_break
    "[--BREAK--]"
  end
  def write_up_summary(post, options = {})
    omit=options.fetch(:omit, %Q{["... read more":#{url_for(post)}]})
    split=post.write_up.split(writeup_break)
    text=split.first
    text+=omit if split.length>1
    text
  end
  def write_up_detail(write_up)
    write_up.gsub(writeup_break,"")
  end

end
