* @ValidationCode : MjotNzc3NzIzMzg2OkNwMTI1MjoxNjYwNjQ4Njc3MzY0Om5hemliOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX1NQOS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 Aug 2022 17:17:57
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
SUBROUTINE GB.JBL.E.BLD.CHQ.MICR.BOOK.BR(ENQ.DATA)
*
*Retrofitted By:
*    Date         : 16/08/2022
*    Developed By : Md. Nazibul Islam (Peal)
*    Designation  : Software Engineer
*    Email        : nazibul.ntl@nazihargroup.com
*    Attached To  :
*
    $INSERT  I_EQUATE
    $INSERT  I_COMMON
    $INSERT  I_ENQUIRY.COMMON
    
    $USING EB.DataAccess

    SEL.CMD="SELECT FBNK.EB.JBL.MICR.MGT WITH STATUS EQ DISBURSED"
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    SEL.CMD.NAU="SELECT FBNK.EB.JBL.MICR.MGT$NAU WITH STATUS EQ RECEIVED"
    EB.DataAccess.Readlist(SEL.CMD.NAU,SEL.LIST.NAU,'',NO.OF.REC.NAU,RET.CODE.NAU)

    FOR I=1 TO NO.OF.REC
        REMOVE Y.REC.ID FROM SEL.LIST SETTING Y.POS
        IF Y.REC.ID EQ "" THEN
            BREAK
        END
        LOCATE Y.REC.ID IN SEL.LIST.NAU SETTING Y.ID.POS THEN
            CONTINUE
        END
        Y.TEMP :=Y.REC.ID:' '
    NEXT I

    ENQ.DATA<2> = '@ID'
    ENQ.DATA<3> = 'EQ'
    ENQ.DATA<4> = Y.TEMP

RETURN
END
