package com.feiyu.common.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintWriter;

/**
 * Created by cxf on 2018/10/20.
 */

public class FileUtil {

    /**
     * 把字符串保存成文件
     */
    public static void saveStringToFile(File dir, String content, String fileName) {
        PrintWriter writer = null;
        try {
            FileOutputStream os = new FileOutputStream(new File(dir, fileName));
            writer = new PrintWriter(os);
            writer.write(content);
            writer.flush();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } finally {
            if (writer != null) {
                writer.close();
            }
        }
    }
}
