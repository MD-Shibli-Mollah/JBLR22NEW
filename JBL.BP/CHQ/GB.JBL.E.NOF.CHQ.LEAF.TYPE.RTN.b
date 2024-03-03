* @ValidationCode : MjoxMzcyOTUxMjQwOkNwMTI1MjoxNjYwNzI3NTY2NDY3Om5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Aug 2022 15:12:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE GB.JBL.E.NOF.CHQ.LEAF.TYPE.RTN(Y.DATA)

* Description : INPUT Leaf Category Wise
*
*Retrofitted By:
*    Date         : 16/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_ENQUIRY.COMMON
    $INSERT  I_F.CHEQUE.TYPE
    $INSERT  I_F.EB.JBL.MICR.CHQ.BATCH
    
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING CQ.ChqConfig

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*------
INIT:
*------

    FN.CHQ.TYPE='F.CHEQUE.TYPE'
    F.CHQ.TYPE=''

    LOCATE 'TR.TYPE' IN ENQ.SELECTION<2,1> SETTING TR.TYPE.POS THEN
        Y.TR.TYPE =  ENQ.SELECTION<4,TR.TYPE.POS>
    END
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.CHQ.TYPE,F.CHQ.TYPE)
RETURN

PROCESS:
*--------
    SEL.CMD = "SELECT ": FN.CHQ.TYPE :" WITH LT.TR.TYPE EQ ": Y.TR.TYPE

    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    EB.DataAccess.FRead(FN.CHQ.TYPE,SEL.LIST,REC.CHQ.REQ,F.CHQ.TYPE,ERR.REQ)

    EB.LocalReferences.GetLocRef('CHEQUE.TYPE','LT.LEAF.TYPE',Y.PRE.NO)

    Y.DATA = REC.CHQ.REQ<CQ.ChqConfig.ChequeType.ChequeTypeLocalRef,Y.PRE.NO>
RETURN
END
