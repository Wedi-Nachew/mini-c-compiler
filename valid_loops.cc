void f()
{
    while (x)
        return;

    do
    {
        x = x - 1;
    } while (x);

    for (i = 0; i < 10; i = i + 1)
        if (i)
            return;
        else
            return;
}
