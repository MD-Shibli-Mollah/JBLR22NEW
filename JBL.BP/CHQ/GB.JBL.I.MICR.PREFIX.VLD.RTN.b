* @ValidationCode : Mjo4OTgyMTEwNTM6Q3AxMjUyOjE2NjA3MjkxMzI0MjA6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Aug 2022 15:38:52
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
SUBROUTINE GB.JBL.I.MICR.PREFIX.VLD.RTN
* Description : INPUT Prefix validation IN Batch Creation
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
    $INSERT  I_F.EB.JBL.MICR.STOCK.MGT
    $INSERT  I_F.EB.JBL.MICR.CHQ.BATCH
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING CQ.ChqConfig

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*------
INIT:
*------
    FN.MICR.STOCK='FBNK.EB.JBL.MICR.STOCK.MGT'
    F.MICR.STOCK=''

    FN.CHQ.TYPE='F.CHEQUE.TYPE'
    F.CHQ.TYPE=''

RETURN
*
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.MICR.STOCK, F.MICR.STOCK)
    EB.DataAccess.Opf(FN.CHQ.TYPE, F.CHQ.TYPE)
RETURN
*
*--------
PROCESS:
*--------
    !DEBUG
    IF EB.SystemTables.getVFunction() EQ "I" THEN
        Y.SERIES.ID = EB.SystemTables.getRNew(EB.JBL38.SERIES.ID)
        Y.TR.TYPE = EB.SystemTables.getRNew(EB.JBL38.TR.TYPE)
        Y.CHQ.ISS = EB.SystemTables.getRNew(EB.JBL38.LEAF.CODE)
        Y.PRINT.ISS = EB.SystemTables.getRNew(EB.JBL38.TOTAL.BOOK)

*------------------------Leaf Number Validation----------------------------------*

        SEL.CMD = "SELECT ": FN.CHQ.TYPE :" WITH LT.TR.TYPE EQ ": Y.TR.TYPE
        EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

        EB.DataAccess.FRead(FN.CHQ.TYPE,SEL.LIST,REC.CHQ.REQ,F.CHQ.TYPE,ERR.REQ)
        EB.LocalReferences.GetLocRef('CHEQUE.TYPE','LT.LEAF.TYPE',Y.PRE.NO)

        Y.LEAF = REC.CHQ.REQ<CQ.ChqConfig.ChequeType.ChequeTypeLocalRef,Y.PRE.NO>
        FIND Y.CHQ.ISS IN Y.LEAF SETTING Ap, Vp ELSE
            EB.SystemTables.setEtext("Invalid leaf number")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
*------------------------Prefix Validation----------------------------------*

        IF LEFT(Y.SERIES.ID,2) EQ Y.TR.TYPE THEN
            CALL F.READ(FN.MICR.STOCK,Y.SERIES.ID,REC.STOCK,F.MICR.STOCK,ERR.REQ)
            IF REC.STOCK EQ '' OR REC.STOCK<EB.JBL86.STATUS> EQ "CLOSED" THEN
                EB.SystemTables.setEtext("Invalid Cheque Prefix")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
        ELSE
            EB.SystemTables.setEtext("Invalid Cheque Prefix")
            EB.ErrorProcessing.StoreEndError()
        END
*------------------------Printing Book Slot Validation----------------------------------*

        IF Y.PRINT.ISS NE '' THEN
            EB.LocalReferences.GetLocRef('CHEQUE.TYPE','LT.PRINT.SLOT',Y.PRE.NO1)

            Y.PRINT.SLOT = REC.CHQ.REQ<CQ.ChqConfig.ChequeType.ChequeTypeLocalRef,Y.PRE.NO1>
            FIND Y.PRINT.ISS IN Y.PRINT.SLOT SETTING Ap, Vp ELSE
                EB.SystemTables.setEtext("Invalid Book Number")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END
RETURN
END
