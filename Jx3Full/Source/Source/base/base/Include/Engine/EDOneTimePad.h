/*****************************************************************************************
//	译码与解码--“一次一密码乱本(one-time pad)”的变体
//	Copyright : Kingsoft 2002
//	Author	:   Wooy(Wu yue)
//	CreateTime:	2002-8-22
------------------------------------------------------------------------------------------

    ■■ 此为简单加密 ■■
	“一次一密码乱本(one-time pad)”原为高度机密，但是因为此处密钥不是真随机密钥所以机密度
不高。此处密钥根据几个初始字符、明文以及生成的秘文字符共同组合形成。因为密钥选取方式的变化
一个密钥字符的改变一般将引起多个密文字符的改变。

	明文与密文字符的取值范围都是' '至'~'暨0x20至0xfe。明文与秘文存储容量保持一致。
	
	整个字符串采用“一次一密码乱本(one-time pad)”的变体法加密存储。运算速度非常快。
*****************************************************************************************/
#ifndef _ENGINE_EDONETIMEPAD_H_
#define _ENGINE_EDONETIMEPAD_H_

extern "C"
{
	void EDOneTimePad_Encipher(char* pPlaintext, int nPlainLen);		//一次一密码乱本译码函数
	void EDOneTimePad_Decipher(char* pCiphertext, int nCiphertextLen);	//一次一密码乱本解码函数
}
#endif // _ENGINE_EDONETIMEPAD_H_
