#include <stdlib.h>
#include <gtk/gtk.h>
#include <gdk/gdk.h>

int main (int argc, char *argv[])
{

      // Initialize GTK+
      g_log_set_handler ("Gtk", G_LOG_LEVEL_WARNING, (GLogFunc) gtk_false, NULL);
      gtk_init (&argc, &argv);
      g_log_set_handler ("Gtk", G_LOG_LEVEL_WARNING, g_log_default_handler, NULL);

      crearTablero();
      return 0;
}

char intToChar(int num)
{
    char var;
    switch(num){
    case 0:
        var = '0';
        break;
    case 1:
        var = '1';
        break;
    case 2:
        var = '2';
        break;
    case 3:
        var = '3';
        break;
    case 4:
        var = '4';
        break;
    case 5:
        var = '5';
        break;
    }
    return var;
}

char intToLetter(int num)
{
    char var;
    switch(num){
    case 0:
        var = 'A';
        break;
    case 1:
        var = 'B';
        break;
    case 2:
        var = 'C';
        break;
    case 3:
        var = 'D';
        break;
    case 4:
        var = 'E';
        break;
    case 5:
        var = 'F';
        break;
    }
    return var;
}

GdkGC* contextColor(GdkDrawable *window, int red, int green, int blue){
    GdkGC *config = gdk_gc_new(window);
    GdkColor color;
    color.blue=blue;
    color.green=green;
    color.red=red;
    gdk_gc_set_rgb_fg_color(config, &color);
    return gdk_gc_ref(config);
}
gboolean expose_event_callback (GtkWidget *widget, GdkEventExpose *event, gpointer data)
{
    int (*tablero)[6] = (int (*)[6])data;
    int i,j,red,green,blue;

    for(i=0; i < 6; i++)
    {
        char column = intToChar(i);
        char row = intToLetter(i);
        gdk_draw_text(widget->window,
                  gdk_font_load("-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1"),
                  gdk_gc_new(widget->window),
                  120+i*50, 80, &column, 1);
        gdk_draw_text(widget->window,
                  gdk_font_load("-adobe-helvetica-bold-r-normal--12-120-75-75-p-70-iso8859-1"),
                  gdk_gc_new(widget->window),
                  70, 130+i*50, &row, 1);
        for(j=0; j < 6; j++)
        {
            switch(tablero[i][j])
            {
            case 0:
                red=65535;green=65535;blue=65535;
                break;
            case 1:
                red=65535;green=0;blue=0;
                break;
            case 2:
                red=0;green=65535;blue=0;
                break;
            case 3:
                red=0;green=0;blue=65535;
                break;
            }
            gdk_draw_arc (widget->window,
                  contextColor(widget->window,red,green,blue),
                  TRUE,
                  100+j*50, 100+i*50, 50, 50,
                  0, 64 * 360);
        }
    }
    return TRUE;
}

void crearTablero(){
    int tablero[6][6] = {{1,2,3,1,2,3},
                        {0,0,0,0,0,0},
                        {0,0,0,0,0,0},
                        {0,0,2,0,0,0},
                        {0,0,0,0,0,0},
                        {0,3,0,0,2,0}};
    //crear la ventana
      GtkWidget *window;
      GtkWidget *container;
      container = gtk_vbox_new(1,4);
      window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
      gtk_widget_set_size_request (window,
                             800,
                             600);
      GtkWidget *drawing_area = gtk_drawing_area_new ();
      gtk_widget_set_size_request (drawing_area, 800, 600);
      g_signal_connect (G_OBJECT (drawing_area), "expose_event",
                        G_CALLBACK (expose_event_callback), tablero);
      gtk_container_add (GTK_CONTAINER (container), drawing_area);
      gtk_container_add (GTK_CONTAINER (window), container);
      gtk_widget_show_all(window);
      gtk_main ();
}
