package test;

class Thing {
    public static int count = 0;
    private int field = 0;

    public Thing() {
        count++;
    }

    public static int getCount() {
        return count;
    }

    public static void incrementCount() {
        count++;
    }

    public int pfield() {
        return field;
    }
}

class Foo extends Thing {
    public static int count = 0;
    private int field = 10;

    public Foo() {
        incrementCount();
    }

    public static int getCount() {
        return count;
    }
}

class Test {
    public static void main(String[] args) {
        System.out.println(new Foo().pfield());
    }
}