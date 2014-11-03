module StaticPagesHelper

	def render_legal(file)
		file = File.read("public/legal/#{file}.txt").split("\n")
		html = ""
		file.map do |line|
			line_split = line.split
			case line_split[0]
			when "="
				line_split.shift
				html += "<h2 class='subheader'>#{line_split.join(" ")}</h2>"
			when "=="
				line_split.shift
				html += "<h4 class='subheader'>#{line_split.join(" ")}</h4>"
			else
				html += "<p>#{line_split.join(" ")}</p>"
			end
		end
		return html
	end
end
