* @ValidationCode : Mjo1NzUyMDQzMTY6Q3AxMjUyOjE2NjA2NDg5NTI2NTk6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 Aug 2022 17:22:32
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
SUBROUTINE GB.JBL.I.MICR.CHQ.INPUT.RTN
*
* Description : AUTO INPUT Cheque Number, Prefix and Status
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
    $INSERT  I_F.EB.JBL.MICR.STOCK.MGT
    $INSERT  I_F.EB.JBL.MICR.MGT
    
    $USING EB.DataAccess
    $USING EB.SystemTables

    FN.MICR.MGT = 'FBNK.EB.JBL.MICR.MGT'
    F.MICR.MGT = ''

    FN.STOCK = 'FBNK.EB.JBL.MICR.STOCK.MGT'
    F.STOCK = ''


    Y.MICR.ID = EB.SystemTables.getIdNew()

    EB.DataAccess.Opf(FN.MICR.MGT, F.MICR.MGT)
    EB.DataAccess.Opf(FN.STOCK, F.STOCK)
    IF EB.SystemTables.getVFunction() EQ "I" THEN
        EB.DataAccess.FRead(FN.MICR.MGT,Y.MICR.ID,REC.MICR,F.MICR.MGT,ERR.REQ)
        !DEBUG
        Y.TR.TYPE = REC.MICR<EB.JBL82.TR.TYPE>

        Y.TOTAL.LEAF = REC.MICR<EB.JBL82.NO.OF.BOOK> * REC.MICR<EB.JBL82.LEAF.TYPE>

        SEL.CMD = "SELECT ": FN.STOCK : " WITH TR.TYPE EQ ": Y.TR.TYPE : " AND BALANCE GE ": Y.TOTAL.LEAF

        EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

        EB.DataAccess.FRead(FN.STOCK,SEL.LIST,REC.STOCK,F.STOCK,ERR.STOCK)

        EB.SystemTables.setRNew(EB.JBL82.SERIES.ID, REC.STOCK<EB.JBL86.TR.PREFIX>)
        EB.SystemTables.setRNew(EB.JBL82.STARTING.NO, FMT((REC.STOCK<EB.JBL86.LAST.USED.NO> + 1), 'R0%7'))
        EB.SystemTables.setRNew(EB.JBL82.ENDING.NO, FMT((REC.STOCK<EB.JBL86.LAST.USED.NO> + Y.TOTAL.LEAF), 'R0%7'))
        EB.SystemTables.setRNew(EB.JBL82.PREFIX.NO, REC.STOCK<EB.JBL86.PREFIX.NO>)

        REC.STOCK<EB.JBL86.LAST.USED.NO> = EB.SystemTables.getRNew(EB.JBL82.ENDING.NO)
        REC.STOCK<EB.JBL86.BALANCE> = REC.STOCK<EB.JBL86.BALANCE> - Y.TOTAL.LEAF

*EB.DataAccess.FWrite(FN.STOCK,SEL.LIST,REC.STOCK)
        WRITE REC.STOCK ON F.STOCK,SEL.LIST

        REC.MICR<EB.JBL82.STATUS> = 'PROCESSING'
        IF REC.MICR THEN
            WRITE REC.MICR ON F.MICR.MGT,Y.MICR.ID
        END
    END
RETURN
END
