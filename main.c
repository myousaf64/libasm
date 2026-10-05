#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

size_t	ft_strlen(const char *s);
char	*ft_strcpy(char *dst, const char *src);
int		ft_strcmp(const char *s1, const char *s2);
ssize_t	ft_write(int fd, const void *buf, size_t count);
ssize_t	ft_read(int fd, void *buf, size_t count);
char	*ft_strdup(const char *s);
void	*ft_calloc(size_t nmemb, size_t size);

static int	g_fail;

static void	check(int ok, const char *name)
{
	printf("[%s] %s\n", ok ? "OK" : "KO", name);
	if (!ok)
		g_fail = 1;
}

static int	sign(int n)
{
	return ((n > 0) - (n < 0));
}

static void	test_strlen(void)
{
	check(ft_strlen("") == 0, "strlen empty");
	check(ft_strlen("hello") == 5, "strlen hello");
}

static void	test_strcpy(void)
{
	char	buf[32];

	check(ft_strcpy(buf, "abc") == buf && strcmp(buf, "abc") == 0,
		"strcpy abc");
	check(ft_strcpy(buf, "") == buf && buf[0] == '\0', "strcpy empty");
}

static void	test_strcmp(void)
{
	const char	*s[][2] = {{"", ""}, {"abc", "abc"}, {"abc", "abd"},
		{"abd", "abc"}, {"ab", "abc"}, {"abc", "ab"}, {"\x80", "a"},
		{"a", "\xff"}};
	size_t		i;
	char		name[32];

	i = 0;
	while (i < sizeof(s) / sizeof(s[0]))
	{
		snprintf(name, sizeof(name), "strcmp case %zu", i);
		check(sign(ft_strcmp(s[i][0], s[i][1]))
			== sign(strcmp(s[i][0], s[i][1])), name);
		i++;
	}
}

static void	test_write(void)
{
	errno = 0;
	check(ft_write(1, "write ok\n", 9) == 9, "write stdout");
	errno = 0;
	check(ft_write(-1, "x", 1) == -1 && errno == EBADF, "write bad fd");
}

static void	test_read(void)
{
	char	buf[16];
	int		fd;

	fd = open("main.c", O_RDONLY);
	check(ft_read(fd, buf, 8) == 8 && memcmp(buf, "#include", 8) == 0,
		"read file");
	errno = 0;
	check(ft_read(fd, NULL, 1) == -1 && errno == EFAULT, "read bad buffer");
	close(fd);
	errno = 0;
	check(ft_read(-1, buf, 1) == -1 && errno == EBADF, "read bad fd");
}

static void	test_strdup(void)
{
	char	*d;

	d = ft_strdup("hello");
	check(d && strcmp(d, "hello") == 0, "strdup hello");
	free(d);
	d = ft_strdup("");
	check(d && d[0] == '\0', "strdup empty");
	free(d);
}

static void	test_calloc(void)
{
	unsigned char	*p;
	size_t			i;
	int				zero;

	p = ft_calloc(64, 4);
	zero = (p != NULL);
	i = 0;
	while (p && i < 256)
		zero &= (p[i++] == 0);
	check(zero, "calloc 64x4 zeroed");
	free(p);
	errno = 0;
	check(ft_calloc(SIZE_MAX, 2) == NULL && errno == ENOMEM,
		"calloc overflow");
	p = ft_calloc(0, 8);
	check(1, "calloc zero size no crash");
	free(p);
}

int	main(void)
{
	test_strlen();
	test_strcpy();
	test_strcmp();
	test_write();
	test_read();
	test_strdup();
	test_calloc();
	return (g_fail);
}
