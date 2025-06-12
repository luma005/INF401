# Chemin vers le compilateur croisé ARM
CC = /opt/gnu/arm/bin/arm-eabi-gcc
AS = /opt/gnu/arm/bin/arm-eabi-gcc

# Options de compilation
CFLAGS = -Wall -gdwarf-2

# Nom de l'exécutable final
EXEC = prog_map prog_red prog_map2_iterative prog_map2_rec

# fichiers sources
m_SRC = essai-map.s map.s fg.s gestion_tab.s es.s 

r_SRC = fg.s gestion_tab.s es.s red.s essai-red.s

m2i_SRC = essai-map2i.s map2i.s fg.s gestion_tab.s es.s #version iterative

m2r_SRC = essai-map2r.s map2r.s fg.s gestion_tab.s es.s #version recurssive

# fichiers objets
m_OBJS = $(m_SRC:.s=.o)
r_OBJS = $(r_SRC:.s=.o)
m2i_OBJS = $(m2i_SRC:.s=.o)
m2r_OBJS = $(m2r_SRC:.s=.o)

all: $(EXEC)

# linking
prog_map: $(m_OBJS)
	$(CC) $(CFLAGS) $^ -o $@

prog_red: $(r_OBJS)
	$(CC) $(CFLAGS) $^ -o $@

prog_map2_iterative: $(m2i_OBJS)
	$(CC) $(CFLAGS) $^ -o $@

prog_map2_rec: $(m2r_OBJS)
	$(CC) $(CFLAGS) $^ -o $@

# compilation
%.o: %.s
	$(AS) $(CFLAGS) -c $< -o $@


clean:
	rm -f *.o $(EXEC)
