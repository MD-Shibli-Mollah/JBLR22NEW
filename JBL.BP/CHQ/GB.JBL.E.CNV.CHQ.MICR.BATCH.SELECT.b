* @ValidationCode : Mjo4OTM3OTk3MTA6Q3AxMjUyOjE2NjA5OTE1OTA4MTQ6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 20 Aug 2022 16:33:10
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
SUBROUTINE GB.JBL.E.CNV.CHQ.MICR.BATCH.SELECT
!PROGRAM GB.JBL.E.CNV.CHQ.MICR.BATCH.SELECT
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
    $INSERT  I_F.EB.JBL.MICR.CHQ.BATCH
    $INSERT  I_F.EB.JBL.MICR.MGT
    
    $USING EB.DataAccess
    $USING EB.Reports

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*------
INIT:
*------
    FN.MICR.NAU="FBNK.EB.JBL.MICR.MGT$NAU"
    F.MICR=""

    FN.BAT.NAU="FBNK.EB.JBL.MICR.CHQ.BATCH$NAU"
    F.BAT.NAU=""
*
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.MICR.NAU,F.MICR.NAU)
    EB.DataAccess.Opf(FN.BAT.NAU,F.BAT.NAU)
RETURN
*
*--------
PROCESS:
*--------
    Y.MICR.ID = ""
    Y.BATCH.ID = EB.Reports.getOData()
    *Y.BATCH.ID = 'MICR.20220427.153905'
    W.ENQ.KEYS = ""

    EB.DataAccess.FRead(FN.BAT.NAU,Y.BATCH.ID,REC.BAT,F.BAT.NAU,BAT.ERR)

    IF REC.BAT NE '' AND REC.BAT<EB.JBL38.STATUS> EQ "CREATE" THEN
        Y.PREFIX=REC.BAT<EB.JBL38.SERIES.ID>
        Y.TOT.BOOK=REC.BAT<EB.JBL38.TOTAL.BOOK> - REC.BAT<EB.JBL38.PENDING.BOOK>
        !     DEBUG
        IF Y.TOT.BOOK GT 0 THEN
            !SEL.CMD = "SELECT ": FN.MICR.NAU : " WITH SERIES.ID EQ ": Y.PREFIX : " AND STATUS EQ ACCEPT AND NO.OF.BOOK LE ": Y.TOT.BOOK : " AND BATCH.NO EQ '' BY-DSND NO.OF.BOOK"
            SEL.CMD = "SELECT ": FN.MICR.NAU : " WITH SERIES.ID EQ ": Y.PREFIX : " AND STATUS EQ ACCEPT AND BATCH.NO EQ '' BY-DSND NO.OF.BOOK"
            
            EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

            FOR I = 1 TO NO.OF.REC

                Y.MICR.ID = SEL.LIST<I>
                
                EB.DataAccess.FRead(FN.MICR.NAU,Y.MICR.ID,R.MICR,F.MICR.NAU,MICR.ERR)
                
                IF R.MICR<EB.JBL82.NO.OF.BOOK> LE Y.TOT.BOOK THEN

                    IF ENQ.KEYS<I> NE "" THEN
                        W.ENQ.KEYS<-1> = ENQ.KEYS<I>
                    END
                    Y.TOT.BOOK = Y.TOT.BOOK - R.MICR<EB.JBL82.NO.OF.BOOK>

                END

                IF Y.TOT.BOOK LE 0 THEN
                    BREAK
                END
            NEXT I
        END

        ENQ.KEYS = ""
        ENQ.KEYS = W.ENQ.KEYS
        RETURN
    END
