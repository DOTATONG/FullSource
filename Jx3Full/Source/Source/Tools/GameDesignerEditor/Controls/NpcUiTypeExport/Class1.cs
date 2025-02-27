using System;

using System.Collections.Generic;

using System.Text;

using System.Data.SqlClient;

using System.Data;

using System.IO;

using System.Collections;



namespace NpcUiTypeExport

{

    public class Class1

    {

        public Class1()

        {



        }



        public bool Export(SqlConnection Conn, string RootDir)

        {

            StringBuilder sb = new StringBuilder();

            sb.Append("TemplateID\tTypeID\r\n");



            string sql = "select id,name,title,shopoptiontext,craftmasterid,masterid,hasbank,hasmailbox from npctemplate where (shopoptiontext is not null and shopoptiontext!='0') or craftmasterid!=0 or masterid!=0 or hasbank!=0 or hasmailbox!=0 or title like '%车夫%' or title like '%船夫%' or title like '%·守卫%' order by id";

            DataTable tbl = Helper.GetDataTable(sql, Conn);

            

            string strGuard = "·守卫";



            foreach (DataRow row in tbl.Rows)

            {

                int npctype = 0;



                if (row["title"].ToString().Contains("车夫") || row["title"].ToString().Contains("船夫"))

                {

                    npctype = 17;

                }

                else if (!IsLogicallyNull(row["CraftMasterID"]))

                {

                    npctype = 13;

                }

                else if (!IsLogicallyNull(row["MasterID"]))

                {

                    npctype = 14;

                }

                else if (!IsLogicallyNull(row["HasBank"]))

                {

                    npctype = 15;

                }

                else if (!IsLogicallyNull(row["HasMailBox"]))

                {

                    npctype = 16;

                }

                else if (row["title"].ToString().Contains(strGuard))

                {

                    if (row["title"].ToString().Contains(strGuard))

                        npctype = 18;

                }

                else if (!IsLogicallyNull(row["ShopOptionText"]))

                {

                    npctype = GetShopTypeByShopOptionText(row["ShopOptionText"].ToString().Trim());

                }



                if (npctype != 0)

                {

                    int npctemplateid = Convert.ToInt32(row["ID"]);

                    sb.Append(npctemplateid.ToString());

                    sb.Append("\t");

                    sb.Append(npctype.ToString());

                    sb.Append("\r\n");

                }

            }



            // 写文件

            string targetFileName = RootDir + "/ui/scheme/case/npc.txt";

            Helper.StringToFile(sb.ToString(), targetFileName, Encoding.GetEncoding("gb2312"));



            return true;

        }



        private int GetShopTypeByShopOptionText(string shopoptiontext)

        {

            if (shopoptiontext.Contains("武器店"))

                return 1;

            else if (shopoptiontext.Contains("朊装店"))

                return 2;

            else if (shopoptiontext.Contains("饰品店"))

                return 3;

            else if (shopoptiontext.Contains("杂货店"))

                return 4;

            else if (shopoptiontext.Contains("药品店"))

                return 5;

            else if (shopoptiontext.Contains("背包店"))

                return 10;

            else if (shopoptiontext.Contains("食品店"))

                return 6;

            else if (shopoptiontext.Contains("阅读材料供应店"))

                return 7;

            else if (shopoptiontext.Contains("材料供应店") || (shopoptiontext.Contains("烹饪") && shopoptiontext.Contains("店")))

                return 12;

            else if (shopoptiontext.Contains("马厩"))

                return 8;

            else if (shopoptiontext.Contains("稀有物品店"))

                return 9;

            else if (shopoptiontext.Contains("物资官"))

                return 11;





            return 0;

        }



        private bool IsLogicallyNull(object DbField)

        {

            if (DbField == null || DbField == DBNull.Value || DbField.ToString().Trim() == string.Empty || DbField.ToString().Trim() == "0" || DbField.ToString().Trim() == "False") // 可以认为是空的数据

                return true;

            else

                return false;

        }

    }

}

