class ParserRepository


end


load parser repository





  parser repo
    - parser_repo would read the csv and define csv
    - has method for returning the appropriate parser based on the filepath it's given; look at file path to figure out which parser needs to deal with it.



  parser
  - takes @csv
  - packages data in different ways based on string
    - if "./data/Kindergartners in full-day program.csv"
      then  consolidates data
            prepares pretty data



    --looks for parser instances with given key (:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"})

    --

    location.fetch(:enrollment).fetch(:kindergarten)
#   --initialze(filepath) **((:enrollment => {:kindergarten => "./data/Kindergartners in full-day program.csv"}}))
#
#     --based on filepath, create appropriate parser(:enrollment:kindergarten - parser)
#       - assigns a key-value pair to its parser_hash
#       - key is filepath, value is parser instance
#       - that parser instance is fed the csv handle
#
#
#
#
# Dist Repo
#
# load Data
# take that filepath, and give it to parser repo
#
# needs to get at least the list of names back so it can create districts
#
#
#
# Enroll repo
# stay out of this
# just get data from appropriate parser (which comes from DR)
#
