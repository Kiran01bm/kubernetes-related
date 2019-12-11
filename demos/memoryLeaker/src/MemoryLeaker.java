package com.demos.oom;

import java.util.*;

public class MemoryLeaker {
    public static void main(String[] args) throws Exception {
        Map<Long, String> map = new HashMap<Long, String>();
        for (long i = 1; true; i++) {
	    System.out.println("Continue leaking.."+i);
            StringBuilder sb = new StringBuilder();
            for (long j = 0; j < i; j++) {
                sb.append("x");
            }
            map.put(i, sb.toString());

            if (i % 1000 == 0) {
                System.out.print(".");
                Thread.sleep(5000);
            }
        }
    }
}
