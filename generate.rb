require 'prawn'
require 'yaml'

input = ARGV.fetch(0)
output = ARGV.fetch(1)

faves = YAML.load_file(input)

rows = 4
cols = 4
gutter = 40
show_grid = false

Prawn::Document.generate(output, page_size: 'A4', margin: gutter/2) do |pdf|
  pdf.define_grid(rows: rows, columns: cols, gutter: gutter)
  pdf.grid.show_all if show_grid

  faves.each_with_index do |tweet, index|
    row = (index / cols).floor % rows
    col = index % cols

    if index > 0 and row == 0 and col == 0
      pdf.start_new_page
      pdf.grid.show_all if show_grid
    end

    pdf.grid(row, col).bounding_box do
      pdf.bounding_box([0, pdf.bounds.top], :width => pdf.bounds.right, :height => pdf.bounds.top) do
        pdf.text tweet["text"],
          size: 11,
          align: :center,
          valign: :center
      end

      pdf.text_box '@'+tweet["user"]["screen_name"],
        size: 9,
        at: [0, pdf.bounds.bottom + 10],
        height: 10,
        width: pdf.bounds.right,
        align: :center
    end
  end
end