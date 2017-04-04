# Major & Minor categories to create survey answers mock data

# MAJOR

major.cats <- as.factor(c("Cat1", "Cat2", "Cat3",
                "Cat4", "Cat5"))

# MINOR

minor.cats <- list(
  # Cat1
  "Cat1" = as.factor(c(
    "Subcat1",
    "Subcat2",
    "Subcat3",
    "Subcat4",
    "Subcat5",
    "Subcat6",
    "Subcat7",
    "Subcat8"
  )),
  # Cat2
  "Cat2" = as.factor(c(
    "Subcat1",
    "Subcat2",
    "Subcat3",
    "Subcat4"
  )),
  # Cat3
  "Cat3" = as.factor(c(
    "Subcat1",
    "Subcat2",
    "Subcat3",
    "Subcat4",
    "Subcat5"
  )),
  # Cat4
  "Cat4" = as.factor(c(
    "Subcat1",
    "Subcat2",
    "Subcat3",
    "Subcat4",
    "Subcat5",
    "Subcat6"
  )),
  # Cat5
  "Cat5" = as.factor(c(
    "Subcat1",
    "Subcat2",
    "Subcat3",
    "Subcat4"
  ))
)
