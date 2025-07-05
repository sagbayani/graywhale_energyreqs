########## Specify Decimal function ############################
# 
# For use in labelling the plots with equations, and rounding up the coefficients
# to a specific no. of decimal places
specify_decimal <- function(x, k) format(round(x, k), nsmall=k)


############ Multiple plot function######################
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
# Code extracted from Cookbook for R. This site is powered by knitr and Jekyll. 
# If you find any errors, please email winston@stdout.org

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


# functions used for carry out the fit 

## this function is avaible in: 
# http://www.leg.ufpr.br/~walmes/cursoR/ciaeear/as.lm.R   or in 
# https://gist.github.com/TonyLadson/2d63ca70eef92583001dece607127759 (from the line 269)

##### as.lm function: ######

as.lm <- function(object, ...) UseMethod("as.lm")

as.lm.nls <- function(object, ...) {
  if (!inherits(object, "nls")) {
    w <- paste("expected object of class nls but got object of class:", 
               paste(class(object), collapse = " "))
    warning(w)
  }
  
  gradient <- object$m$gradient()
  if (is.null(colnames(gradient))) {
    colnames(gradient) <- names(object$m$getPars())
  }
  
  response.name <- if (length(formula(object)) == 2) "0" else 
    as.character(formula(object)[[2]])
  
  lhs <- object$m$lhs()
  L <- data.frame(lhs, gradient)
  names(L)[1] <- response.name
  
  fo <- sprintf("%s ~ %s - 1", response.name, 
                paste(colnames(gradient), collapse = "+"))
  fo <- as.formula(fo, env = as.proto.list(L))
  
  do.call("lm", list(fo, offset = substitute(fitted(object))))
  
}

############## End as.lm function 



############### proto function: ############
#### proto function avaible in https://github.com/hadley/proto/blob/master/R/proto.R

proto <- function(. = parent.env(envir), expr = {},
                  envir = new.env(parent = parent.frame()), ...,
                  funEnvir = envir) {
  parent.env(envir) <- .
  envir <- as.proto.environment(envir)  # must do this before eval(...)
  # moved eval after for so that ... always done first
  # eval(substitute(eval(quote({ expr }))), envir)
  dots <- list(...); names <- names(dots)
  for (i in seq_along(dots)) {
    assign(names[i], dots[[i]], envir = envir)
    if (!identical(funEnvir, FALSE) && is.function(dots[[i]]))
      environment(envir[[names[i]]]) <- funEnvir
  }
  eval(substitute(eval(quote({
    expr
  }))), envir)
  if (length(dots))
    as.proto.environment(envir)
  else
    envir
}

#' @export
#' @rdname proto
as.proto <- function(x, ...) {
  UseMethod("as.proto")
}

#' @export
#' @rdname proto
as.proto.environment <- function(x, ...) {
  assign(".that", x, envir = x)
  assign(".super", parent.env(x), envir = x)
  structure(x, class = c("proto", "environment"))
}

#' @export
#' @rdname proto
as.proto.proto <- function(x, ...) {
  x
}
as.proto.list <- function(x, envir, parent, all.names = FALSE, ...,
                          funEnvir = envir, SELECT = function(x) TRUE) {
  if (missing(envir)) {
    if (missing(parent))
      parent <- parent.frame()
    envir <- if (is.proto(parent))
      parent$proto(...)
    else
      proto(parent, ...)
  }
  for (s in names(x))
    if (SELECT(x[[s]])) {
      assign(s, x[[s]], envir = envir)
      if (is.function(x[[s]]) && !identical(funEnvir, FALSE))
        environment(envir[[s]]) <- funEnvir
    }
  if (!missing(parent))
    parent.env(envir) <- parent
  as.proto.environment(envir)  # force refresh of .that and .super
}

#' @export
"$<-.proto" <- function(this,s,value) {
  if (s == ".super")
    parent.env(this) <- value
  if (is.function(value))
    environment(value) <- this
  this[[as.character(substitute(s))]] <- value
  this
}
is.proto <- function(x) inherits(x, "proto")

#' @export
"$.proto" <- function(x, name) {
  inherits <- substr(name, 1, 2) != ".."
  
  res <- get(name, envir = x, inherits = inherits)
  if (!is.function(res))
    return(res)
  
  if (deparse(substitute(x)) %in% c(".that", ".super"))
    return(res)
  
  structure(
    function(...) res(x, ...),
    class = "protoMethod",
    method = res
  )
}

#' @export
print.protoMethod <- function(x, ...) {
  cat("<ProtoMethod>\n")
  print(attr(x, "method"), ...)
}

# modified from Tom Short's original
#' @export
str.proto <- function(object, max.level = 1, nest.lev = 0,
                      indent.str = paste(rep.int(" ", max(0, nest.lev + 1)), collapse = ".."),
                      ...) {
  cat("proto", name.proto(object), "\n")
  Lines <- utils::capture.output(utils::str(
    as.list(object), max.level = max.level,
    nest.lev = nest.lev, ...
  ))[-1]
  for (s in Lines)
    cat(s, "\n")
  if (is.proto(parent.env(object))) {
    cat(indent.str, "parent: ", sep = "")
    utils::str(parent.env(object), nest.lev = nest.lev + 1, ...)
  }
}

#' @export
print.proto <- function(x, ...) {
  if (!exists("proto_print", envir = x, inherits = TRUE))
    return(NextMethod())
  
  x$proto_print(...)
}

############# End proto function 
