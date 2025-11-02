package test;

class Thing {
    public static int count = 0;

    public Thing() {
        count++;
    }

    public static int getCount() {
        return count;
    }

    public static void incrementCount() {
        count++;
    }
}

class Foo extends Thing {
    public static int count = 0;
    public Foo() {
        incrementCount();
    }

    public static int getCount() {
        return count;
    }
}

class Test {
    public static void main(String[] args) {
        new  Thing();
        new Thing();
        System.out.println(Foo.getCount());
    }
}