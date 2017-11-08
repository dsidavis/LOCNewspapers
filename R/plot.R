plot.ABBYY =
function(x, y, cex = .5, imageFile = NA,
         img = if(is.na(imageFile)) NULL else readImage(imageFile),...)
{
    mx = range(x$HPOS)
    my = range(x$VPOS)
    
    plot(0, type = "n", xlim = mx, ylim = my, xlab = "", ylab = "", ...)
    if(!is.null(img))
        rasterImage(img, mx[1], my[1], mx[2], my[2])
    
    text(x$HPOS, max(x$VPOS) - x$VPOS, x$CONTENT, adj = 0, cex = cex, col = "red")
}
