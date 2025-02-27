using System;
using System.IO;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Runtime.InteropServices;


namespace ClientDiff
{
    public class FileFolderHelper
    {
        // import
        [DllImport("kernel32")]
        private static extern long WritePrivateProfileString(string section, string key, string val, string filePath);

        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section, string key, string def, StringBuilder retVal, int size, string filePath);

        //从完整文件名到场景名
        static public string GetMapName(string strFileName)
        {
            int lastSlash = strFileName.LastIndexOfAny(new char[] { '\\', '/' });
            if (lastSlash == -1)
                return "<未知场景名>";
            else
            {
                string name = strFileName.Substring(lastSlash + 1);
                int firstdot = name.IndexOf('.');
                name = name.Substring(0, firstdot);
                return name;
            }
        }

        // public method
        // 浏览已存在文件
        static public string BrowseFile(string[] postfixes, string initDir)
        {
            string filter = "";
            foreach (string postfix in postfixes)
            {
                if (postfix != "")
                    filter += string.Format("{0} 文件|*.{1}|", postfix, postfix);
            }

            OpenFileDialog ofd = new OpenFileDialog();
            ofd.InitialDirectory = initDir;
            ofd.Filter = filter + "全部文件|*.*";
            if (ofd.ShowDialog() == DialogResult.OK)
                return ofd.FileName;
            else
                return string.Empty;
        }
        static public string BrowseFile()
        {
            return BrowseFile(new string[] { "" }, Application.StartupPath);
        }
        static public string BrowseFile(string[] postfixes)
        {
            return BrowseFile(postfixes, Application.StartupPath);
        }
        // 浏览要保存的文件
        static public string BrowseFileSave()
        {
            SaveFileDialog sfd = new SaveFileDialog();
            sfd.Filter = "All Files|*.*";
            if (sfd.ShowDialog() == DialogResult.OK)
                return sfd.FileName;
            else
                return "";
        }
        // 保存string到文件
        static public void StringToFile(string strContent, string strFileName)
        {
            StringToFile(strContent, strFileName, Encoding.GetEncoding("gb2312")); // 解决乱码关键在于Encoding
        }
        static public void WriteStringToFile(string strContent, string strFileName)
        {
            StringToFile(strContent, strFileName); // 解决乱码关键在于Encoding
        }
        static public void StringToFile(string strContent, string strFileName, Encoding encoding)
        {
            if (!File.Exists(strFileName))
            {
                File.Create(strFileName).Close();
            }
            StreamWriter writer = new StreamWriter(strFileName, false, encoding);
            writer.Write(strContent);
            writer.Close();
        }
        // 读取文件到string
        static public string FileToString(string strFileName)
        {
            return FileToString(strFileName, Encoding.GetEncoding("gb2312"));
        }
        static public string FileToString(string strFileName, Encoding encoding)
        {
            StreamReader reader;
            try
            {
                reader = new StreamReader(strFileName, encoding);
            }
            catch //(Exception e)
            {
                //MessageBox.Show(e.Message);
                return "";
            }

            //StreamReader reader = new StreamReader(strFileName, encoding);
            string strContent = reader.ReadToEnd();
            reader.Close();
            return strContent;
        }
        // ini文件操作
        static public int ReadIniFile(string section, string key, string def, StringBuilder retVal, int size, string filePath)
        {
            return GetPrivateProfileString(section, key, def, retVal, size, filePath);
        }
        static public long WriteIniFile(string section, string key, string val, string filePath)
        {
            return WritePrivateProfileString(section, key, val, filePath);
        }
        // 文件绝对路径名 -> 纯文件名
        static public string FullPathToFileName(string strFullPath)
        {
            int lio1 = strFullPath.LastIndexOf('/');
            int lio2 = strFullPath.LastIndexOf('\\');
            return strFullPath.Substring(lio1 > lio2 ? lio1 + 1 : lio2 + 1);
        }

    }
}
